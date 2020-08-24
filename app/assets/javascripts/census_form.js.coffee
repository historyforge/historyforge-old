censusRecordScroller = (evt, chg) ->
    this.scrollLeft += (chg * 25)
    evt.preventDefault()

$.fn.extend
  disableWrapper: ->
    this.each ->
      $(this).addClass('disabled').find('input').attr('disabled', true)
  enableWrapper: ->
    this.each ->
      $(this).removeClass('disabled').find('input').removeAttr('disabled', true)
  toggleDependents: ->
    this.each ->
      value = if $(this).is("[type=checkbox]") then $(this).is(':checked') else $(this).val()
      name = this.getAttribute('name')
      attribute_name = name.match(/census_record\[(\w+)\]/)[1]
      dependent = $(this).closest('[data-dependents]').attr('data-dependents')
      if value.toString() is dependent.toString()
        console.log 'doing it for ' + attribute_name + " because #{value.toString()} is #{dependent.toString()}"
        $(".form-group[data-depends-on=#{attribute_name}]").enableWrapper()
      else
        $(".form-group[data-depends-on=#{attribute_name}]").disableWrapper()

showHints = window.localStorage.getItem('hints')
showHints = eval(showHints) if typeof showHints is 'string'
#showHints = true if showHints is null
toggleHints = () ->
  showHints = !showHints
  window.localStorage.setItem('hints', showHints)
  setHints()

setHints = () ->
  $('.hint-toggle-btn').text if showHints then 'Showing hints' else 'Hiding hints'
  $('.census-hint-wrapper').hide() unless showHints

#setSupplementalRecord = () ->
#  line = parseInt $('#census_record_line_number').val()
#  if line is 14 or line is 29 or line is 55 or line is 68
#    $('.supplemental').show().find('input').removeAttr('disabled')
#  else
#    $('.supplemental').hide().find('input').attr('disabled', yes)

$(document).ready ->
  setHints()
  $('.hint-toggle-btn').on 'click', toggleHints
  $('#new_census_record, #edit_census_record').on "keypress", (e) ->
    code = e.keyCode or e.which
    if code is 13
      e.preventDefault()
      return false

#  $('#census_record_line_number').on 'change', setSupplementalRecord
#  setSupplementalRecord()

  $('#new_census_record, #edit_census_record').find('input[data-type=other-radio-button]').each ->
    unless $(this).val().length
      $(this).attr('disabled', yes)

  $('#new_census_record, #edit_census_record').find('input[type=radio][value!=other]').on 'click', ->
    $input = $(this).closest('.form-group').find('input[data-type=other-radio-button]')
    $input.val(null).attr('disabled', yes)

  $('#new_census_record, #edit_census_record').find('input[type=radio][value=other]').on 'click', ->
    $input = $(this).next().find('input[type=text]')
    if $(this).is(':checked')
      $input.removeAttr('disabled').focus()
    else
      $input.attr('disabled', yes)

  $('#new_census_record, #edit_census_record').find('input[autocomplete=new-password]').each ->
    name = this.getAttribute('name')
    attribute_name = name.match(/census_record\[(\w+)\]/)[1]
    urlParts = document.location.pathname.split('/');
    url = "/census/#{urlParts[2]}/autocomplete?attribute=#{attribute_name}"
    $(this).autocomplete source: url, select: => $(this).trigger('click')

  $('input[data-type="other-radio-button"]').on 'change', ->
    $(this).closest('.form-check').find('input[type=radio]').prop('checked', yes).val $(this).val()

  $('[data-dependents] input').on 'change click', -> $(this).toggleDependents()

  $('[data-dependents]').find('input[type=radio]:checked, input[type=checkbox], input[type=text]').toggleDependents()

#  $('#census_record_age').on 'keyup', ->
#    value = this.value
#    if value? and parseInt(value) < 5
#      $('.census_record_age_months').enableWrapper()
#    else
#      $('.census_record_age_months').disableWrapper()
#
#  $('#census_record_age').trigger('keyup')

  $('#toggle-census-slider button').on 'click', ->
    orientation = $(this).data('orientation')
    window.localStorage.setItem('census-orientation', orientation)
    $('.census-slider').removeClass('hidden')
    if orientation is 'vertical'
      $('button[data-orientation=vertical]').removeClass('btn-secondary').addClass('btn-primary')
      $('button[data-orientation=horizontal]').removeClass('btn-primary').addClass('btn-secondary')
      $('.census-slider').removeClass('horizontal').addClass('vertical').unmousewheel censusRecordScroller
    else
      $('button[data-orientation=horizontal]').removeClass('btn-secondary').addClass('btn-primary')
      $('button[data-orientation=vertical]').removeClass('btn-primary').addClass('btn-secondary')
      $('.census-slider').addClass('horizontal').removeClass('vertical').mousewheel censusRecordScroller

  orientation = window.localStorage.getItem('census-orientation') or 'vertical'
  $('button[data-orientation=' + orientation + ']').trigger('click')

  if $('.census-slider').hasClass('horizontal')
    $('.census-slider').mousewheel censusRecordScroller

  $('.hint-bubble').each ->
    label = $(this).closest('.form-group').children('label')
    title = $ "<span>#{label.html()}<i class='fa fa-close float-right' /></span>"
    icon = $ '<i class="fa fa-question-circle float-right" data-toggle="popover" />'
    label.prepend icon
    title.on('click', () -> icon.popover('hide'))
    icon.popover({ container: 'body', html: true, title: title, content: this.innerHTML, trigger: 'hover' }).on('show.bs.popover', () => $('[data-toggle=popover]').popover('hide'))
    icon.on 'click', (e) ->
      e.stopPropagation()
      e.preventDefault()
  jQuery(document).on 'change', '#census_record_page_side', ->
    value = jQuery(this).val()
    $line = jQuery('#census_record_line_number')
    if value is 'A'
      $line.attr('min', 1)
      $line.attr('max', 50)
    else
      $line.attr('min', 51)
      $line.attr('max', 100)

  $('.census-slider input').on 'focusout', ->
    $(this).closest('.form-group').removeClass('focused')
    $('.census-hint-wrapper').hide()
  $('.census-slider input').on 'focusin', ->
    $(this).closest('.form-group').addClass('focused')
    type = this.getAttribute('type')
    $hint = $('.census-hint')
    hints = ['TAB moves to next field.', 'Shift-TAB moves to previous field.']
    hints.push('Arrow keys move between choices.') if type is 'radio'
    hints.push('SPACE to check the box.') if type is 'radio' or type is 'checkbox'
    hints.push('ENTER selects a choice.')
    $hint.html "<b>HINT:</b> #{hints.join(' ')}"
    $('.census-hint-wrapper').show() if showHints

  # TODO: Refactor these to use the data-dependent API
  jQuery(document).on 'change', '#census_record_relation_to_head', ->
    value = jQuery(this).val()
#    value = value.replace /\b\w/g, (l) -> l.toUpperCase()
    jQuery(this).val(value)
    if value is 'Head'
      jQuery('input[name="census_record[owned_or_rented]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
      jQuery('input[name="census_record[mortgage]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
      jQuery('input[name="census_record[farm_or_house]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
    else
      jQuery('input[name="census_record[owned_or_rented]"]').prop('checked', no).prop('disabled', yes)
      jQuery('input[name="census_record[mortgage]"]').prop('checked', no).prop('disabled', yes)
      jQuery('input[name="census_record[farm_or_house]"]').prop('checked', no).prop('disabled', yes)

  jQuery(document).on 'change', '#census_record_sex', ->
    value = jQuery(this).val()
    if value is 'M'
      jQuery('#census_record_num_children_born').val(null).prop('disabled', yes)
      jQuery('#census_record_num_children_alive').val(null).prop('disabled', yes)
    else if value is 'F'
      jQuery('#census_record_num_children_born').prop('disabled', no)
      jQuery('#census_record_num_children_alive').prop('disabled', no)

  jQuery(document).on 'change', '#census_record_age', ->
    value = jQuery(this).val()
    if value and parseInt(value) < 10
#      jQuery('input[name="census_record[can_read]"]').val(null).prop('disabled', yes)
#      jQuery('input[name="census_record[can_write]"]').val(null).prop('disabled', yes)
      jQuery('#census_record_language_spoken').val(null).prop('disabled', yes)
    else
#      jQuery('input[name="census_record[can_read]"]').prop('disabled', no)
#      jQuery('input[name="census_record[can_write]"]').prop('disabled', no)
      jQuery('#census_record_language_spoken').val('English').prop('disabled', no)

  jQuery(document).on 'change', '#census_record_marital_status', ->
    value = jQuery(this).val()
    if value is 'S' or value is 'D'
      jQuery('#census_record_years_married').val(null).prop('disabled', yes)
    else
      jQuery('#census_record_years_married').val(null).prop('disabled', no)
