getFieldConfig = (attribute) ->
  for key, value of window.attributeFilters["filters"]
    if attribute is key
      return value

getFieldConfigFromScope = (scope) ->
  for attribute, value of window.attributeFilters["filters"]
    return value if value.scopes?[scope]?

getSortableFields = ->
  fields = {}
  for key, value of window.attributeFilters["filters"]
    if value.sortable
      fields[value.sortable] = value.label
  fields

addAttributeFilter = (scope, scopeValue) ->
  field_config = getFieldConfigFromScope(scope)
  return unless field_config?
  return unless field_config.scopes?
  # console.log field_config
  html = document.createElement 'DIV'
  html.classList.add 'attribute-filter'
  html.classList.add 'dropdown-item'
  sentence = [field_config.label]
  for key, value of field_config.scopes
    if key is scope
      sentence.push value
  if scope.match /null$/
    input = document.createElement 'INPUT'
    input.setAttribute 'type', 'hidden'
    input.setAttribute 'name', "s[#{scope}]"
    input.setAttribute 'value', 1
    html.appendChild input
  else switch field_config.type
    when 'boolean'
      input = document.createElement 'INPUT'
      input.setAttribute 'type', 'hidden'
      input.setAttribute 'name', "s[#{scope}]"
      input.setAttribute 'value', '1'
      html.appendChild input
    when 'checkboxes'
      values = []
      for choice in field_config.choices
        if typeof(choice) is 'string'
          label = value = choice
        else
          [label, value] = choice
        for singleScopeValue in scopeValue
          if value.toString() is singleScopeValue.toString()
            values.push label
            input = document.createElement 'INPUT'
            input.setAttribute 'type', 'hidden'
            input.setAttribute 'name', "s[#{scope}][]"
            input.setAttribute 'value', singleScopeValue
            html.appendChild input
      values = values.join ', '
      sentence.push values
    when 'text'
      input = document.createElement 'INPUT'
      input.setAttribute 'type', 'hidden'
      input.setAttribute 'name', "s[#{scope}]"
      input.setAttribute 'value', scopeValue
      html.appendChild input
      sentence.push '"' + scopeValue + '"'
    when 'number'
      input = document.createElement 'INPUT'
      input.setAttribute 'type', 'hidden'
      input.setAttribute 'name', "s[#{scope}]"
      input.setAttribute 'value', scopeValue
      html.appendChild input
      sentence.push scopeValue
    when 'dropdown'
      input = document.createElement 'INPUT'
      input.setAttribute 'type', 'hidden'
      input.setAttribute 'name', "s[#{scope}]"
      input.setAttribute 'value', scopeValue
      html.appendChild input
      for choice in field_config.choices
        label = value = choice
        if scopeValue is value.toString()
          sentence.push label
    when 'daterange'
      input1 = document.createElement 'INPUT'
      input1.setAttribute 'type', 'hidden'
      input1.setAttribute 'name', "s[#{scope}]"
      input1.setAttribute 'value', scopeValue
      html.appendChild input1
      otherScope = scope.replace(/gteq/, 'lteq')
      otherValue = window.currentAttributeFilters[otherScope]
      input2 = document.createElement 'INPUT'
      input2.setAttribute 'type', 'hidden'
      input2.setAttribute 'name', "s[#{otherScope}]"
      input2.setAttribute 'value', otherValue
      html.appendChild input2
      sentence.push moment(scopeValue).format('M/D/YY')
      sentence.push ' to '
      sentence.push moment(otherValue).format('M/D/YY')

  closeButton = document.createElement 'BUTTON'
  closeButton.type = 'button'
  closeButton.classList.add 'close'
  closeButton.classList.add 'remove-filter'
  closeButton.innerHTML = "&times;"

  desc = document.createElement 'P'
  desc.appendChild closeButton
  desc.innerHTML += sentence.join(' ')
  if field_config.append
    desc.innerHTML += field_config.append
  html.appendChild desc

  jQuery('#attribute-filters').append html

jQuery(document).on 'click', '.attribute-filter button.close', ->
  $(this).closest('.attribute-filter').remove()
  $('#new_s').submit()

jQuery(document).on 'click', '.checkall', (e) ->
  e.stopPropagation()
  $cont = $($(this).data('scope'))
  $inputs = $cont.find('input[type=checkbox]')
  if $inputs.filter(':checked').length
    $inputs.attr 'checked', true
  else
    $inputs.removeAttr 'checked'

jQuery(document).on 'change', 'select.scope', ->
  scope = jQuery(this).val()
  name = 's[' + scope + ']'
  form = jQuery(this).closest('.modal-body').find('.value-input-container')
  inputs = form.find('input, select')
  if scope.match /null$/
    if (form.find('input.null-choice').size() > 0)
      inputs.filter(':checked').prop 'checked', no
      form.find('label').hide()
      form.find('input.null-choice').prop('disabled', no).attr('name', name)
    else
      inputs.attr('name', name)
  else
    form.find('label').show()
    form.find('input.null-choice').prop('disabled', yes)
    if inputs.size() > 1
      name += '[]'
    inputs.attr 'name', name

jQuery(document).on 'change', 'select.attribute', ->
  attribute = jQuery(this).val()
  form = jQuery(this).closest('.modal-body')
  field_config = getFieldConfig(attribute)
  if field_config

    scopeSelectContainer = form.find('.scope-selection-container')
    scopeSelectContainer.empty().hide()

    scopeSelect = document.createElement('SELECT')
    scopeSelect.className = 'scope'
    scopeSelect = jQuery scopeSelect
    for key, value of field_config.scopes
      scopeSelect.append "<option value=\"#{key}\">#{value}</option>"
    scopeSelect.find('option:first').prop('selected', true)
    if scopeSelect.find('option').size() is 1
      scopeSelect.hide()
      scopeSelectContainer.append jQuery('<span>' + scopeSelect.find('option:first').text() + '</span>')
    scopeSelectContainer.append(scopeSelect).css('display', 'inline')

    valueBox = form.find('.value-input-container')
    valueBox.hide().empty().prop('className', 'value-input-container').addClass(field_config.type)
    if field_config.columns
      valueBox.addClass 'column-count-' + field_config.columns

    appendToValueBox = (input) ->
      if field_config.append
        div = document.createElement 'DIV'
        div.className = 'input-append'
        span = document.createElement 'SPAN'
        span.className = 'add-on'
        span.appendChild document.createTextNode(field_config.append)
        div.appendChild input
        div.appendChild span
        valueBox.append div
      else
        valueBox.append input
      valueBox.css 'display', 'inline'

    switch field_config.type
      when 'boolean'
        name = "s[" + scopeSelect.val() + "]"
        input = document.createElement 'INPUT'
        input.setAttribute 'name', name
        input.setAttribute 'type', 'hidden'
        input.setAttribute 'value', '1'
        appendToValueBox(input)

      when 'checkboxes'
        null_choice = document.createElement 'INPUT'
        null_choice.type = 'hidden'
        null_choice.disabled = true
        null_choice.className = 'null-choice'
        null_choice.value = 1
        valueBox.append null_choice
        for choice in field_config.choices
          if typeof(choice) is 'string'
            labelText = value = choice
          else
            [labelText, value] = choice
          name = 's[' + scopeSelect.val() + '][]'
          id = 's_' + scopeSelect.val() + '_' + value
          input = document.createElement 'INPUT'
          input.setAttribute 'type', 'checkbox'
          input.setAttribute 'id', id
          input.setAttribute 'name', name
          input.setAttribute 'value', value
          label = document.createElement 'LABEL'
          label.setAttribute 'for', id
          label.className = 'checkbox'
          label.appendChild input
          label.appendChild document.createTextNode(labelText)
          valueBox.append label
        valueBox.show()

      when 'text'
        name = "s[#{scopeSelect.val()}]"
        input = document.createElement 'INPUT'
        input.setAttribute 'name', name
        input.setAttribute 'type', 'text'
        appendToValueBox(input)

      when 'number', 'age', 'time'
        name = "s[#{scopeSelect.val()}]"
        input = document.createElement 'INPUT'
        input.setAttribute 'name', name
        input.setAttribute 'type', 'number'
        appendToValueBox(input)
        scopeSelect.bind 'change', ->
          val = jQuery(this).val()
          if val.match(/null/)
            if input.getAttribute('type') is 'number'
              input.setAttribute('type', 'hidden')
              input.setAttribute('value', '1')
          else if input.getAttribute('type') is 'hidden'
            input.setAttribute('type', 'number')
            input.setAttribute('value', null)
          true

      when 'dropdown'
        choices = field_config.choices
        name = "s[#{scopeSelect.val()}]"
        input = document.createElement 'SELECT'
        input.setAttribute 'name', name
        for choice in choices
          label = value = choice
          option = document.createElement 'OPTION'
          jQuery(option).val value
          jQuery(option).text label
          input.appendChild option
        appendToValueBox(input)

      when 'daterange'
        startDate = moment().startOf('month')
        endDate = moment().endOf('month')
        div = jQuery('<div class="picker"></div>')
        div.append jQuery('<i class="icon-calendar.icon-large"></i>')
        div.append "<span>#{startDate.format('M/D/YY')} - #{endDate.format('M/D/YY')}</span><b class=\"caret\"></b>"
        div.css('display', 'inline')

        from = document.createElement 'INPUT'
        from.setAttribute 'type', 'hidden'
        from.setAttribute 'name', "s[#{scopeSelect.val()}]"
        from.setAttribute 'value', startDate.format('YYYY-MM-DD')
        from.className = 'from'

        to = document.createElement 'INPUT'
        to.setAttribute 'type', 'hidden'
        to.setAttribute 'name', "s[#{scopeSelect.val().replace(/gteq/, 'lteq')}]"
        to.setAttribute 'value', endDate.format('YYYY-MM-DD')
        to.className = 'to'

        valueBox.append from
        valueBox.append to

        appendToValueBox(div)
        valueBox.searchDateRange(startDate, endDate)

    return

jQuery.fn.advancedSearch = (options={}) ->
  @each ->
    url = options.url
    timestamp = options.timestamp
    useCached = options.cache
    fields = options.fields
    filters = options.filters
    sorts = options.sorts

    attributeFiltersCallback = (json) ->
      window.attributeFilters = json
      window.sortedAttributeFilters = []
      for key, value of json['filters']
        window.sortedAttributeFilters.push key: key, label: value.label, value: value

      if Object.entries(filters).length
        $('#attribute-filters').empty()
        for scope, value of filters
          addAttributeFilter scope, value
      c = sorts.c
      d = sorts.d
      jQuery('#c').each ->
        fields = getSortableFields()
        for value, label of fields
          option = document.createElement 'OPTION'
          jQuery(option).val value
          jQuery(option).text label
          jQuery(this).on 'change', -> $('#new_s').submit()
          this.appendChild option
        jQuery(this).val c
      jQuery('#d').each ->
        jQuery(this).append '<option value="asc">up</option><option value="desc">down</option>'
        jQuery(this).val d
        jQuery(this).on 'change', -> $('#new_s').submit()

    if window.localStorage && useCached
      json = null
      last_load = window.localStorage.getItem(url + '_last_load') || 0
      last_load = parseInt(last_load) if last_load?
      if last_load and timestamp < last_load
        json = window.localStorage.getItem(url)

      if json
        attributeFiltersCallback(JSON.parse(json))
      else
        jQuery.getJSON url, (json) ->
          window.localStorage.setItem(url, JSON.stringify(json))
          window.localStorage.setItem('attributes_last_load', (new Date).getTime() / 1000)
          attributeFiltersCallback(json)
    else
      jQuery.getJSON url, (json) ->
        attributeFiltersCallback(json)

    jQuery(document).on 'shown.bs.modal', '#newAttributeFilter', ->
      jQuery(this).find('select.scope').hide()
      jQuery(this).find('.value-input-container').empty()
      attrSelect = jQuery(this).find('select.attribute')
      attrSelect.html "<option>Select field name</option>"

      for key in window.sortedAttributeFilters
        value = key.value
        if value.scopes
          attrSelect.append '<option value="' + key.key + '">' + value.label + '</option>'
    return

jQuery.fn.searchDateRange = (from, to) ->
  this.each ->
    dateRangeOptions =
      startDate: from
      endDate: to
      opens: 'left'
      alwaysShowCalendars: yes
      ranges:
        'Today': [moment(), moment()]
        'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)]
        'Last 7 Days': [moment().subtract('days', 6), moment()]
        'Last 30 Days': [moment().subtract('days', 29), moment()]
        'This Month': [moment().startOf('month'), moment().endOf('month')]
        'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        'This Year': [moment().startOf('year'), moment()]
        'Last Year': [moment().subtract('years', 1).startOf('year'), moment().subtract('years', 1).endOf('year')]
    fromInput = jQuery(this).find('.from')
    toInput = jQuery(this).find('.to')
    picker = jQuery(this).find('.picker')
    picker.daterangepicker dateRangeOptions, (start, end) ->
      start = moment(start)
      end = moment(end)
      console.log start, end
      picker.find('span').html(start.format('M/D/YYYY') + ' - ' + end.format('M/D/YYYY'))
      fromInput.val(start.format('YYYY-MM-DD'))
      toInput.val(end.format('YYYY-MM-DD'))
    return this
