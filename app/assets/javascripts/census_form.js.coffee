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

$(document).ready ->
  $('#new_census_record, #edit_census_record').find('input[autocomplete=new-password]').each ->
    name = this.getAttribute('name')
    attribute_name = name.match(/census_record\[(\w+)\]/)[1]
    urlParts = document.location.pathname.split('/');
    url = "/census/#{urlParts[2]}/autocomplete?attribute=#{attribute_name}"
    $(this).autocomplete source: url

  $('input[data-type="other-radio-button"]').on 'change', ->
    $(this).closest('.form-check').find('input[type=radio]').prop('checked', yes).val $(this).val()

  $('[data-dependents] input').on 'click', ->
    value = this.getAttribute('value')
    name = this.getAttribute('name')
    attribute_name = name.match(/census_record\[(\w+)\]/)[1]
    dependent = $(this).closest('[data-dependents]').attr('data-dependents')
    if value is dependent
      $(".form-group[data-depends-on=#{attribute_name}]").enableWrapper()
    else
      $(".form-group[data-depends-on=#{attribute_name}]").disableWrapper()

  $('[data-dependents] input:checked').trigger('click')

  $('#census_record_age').on 'keyup', ->
    value = this.value
    if value? and parseInt(value) < 5
      $('.census_record_age_months').enableWrapper()
    else
      $('.census_record_age_months').disableWrapper()

  $('#census_record_age').trigger('keyup')

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

  #  $('.census-slider').mousewheel (evt, chg) ->

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
    hints.push('ENTER submits the form.')
    $hint.html "<b>HINT:</b> #{hints.join(' ')}"
    $('.census-hint-wrapper').show()

  # TODO: Refactor these to use the data-dependent API
  jQuery(document).on 'change', '#census_record_relation_to_head', ->
    value = jQuery(this).val()
    value = value.replace /\b\w/g, (l) -> l.toUpperCase()
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
      jQuery('input[name="census_record[can_read]"]').val(null).prop('disabled', yes)
      jQuery('input[name="census_record[can_write]"]').val(null).prop('disabled', yes)
      jQuery('#census_record_language_spoken').val(null).prop('disabled', yes)
    else
      jQuery('input[name="census_record[can_read]"]').prop('disabled', no)
      jQuery('input[name="census_record[can_write]"]').prop('disabled', no)
      jQuery('#census_record_language_spoken').val('English').prop('disabled', no)

  jQuery(document).on 'change', '#census_record_marital_status', ->
    value = jQuery(this).val()
    if value is 'S' or value is 'D'
      jQuery('#census_record_years_married').val(null).prop('disabled', yes)
    else
      jQuery('#census_record_years_married').val(null).prop('disabled', no)
