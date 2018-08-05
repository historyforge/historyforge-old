$(document).ready ->
  jQuery(document).on 'change', '#census_record_page_side', ->
    value = jQuery(this).val()
    $line = jQuery('#census_record_line_number')
    if value is 'A'
      $line.attr('min', 1)
      $line.attr('max', 50)
    else
      $line.attr('min', 51)
      $line.attr('max', 100)

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
