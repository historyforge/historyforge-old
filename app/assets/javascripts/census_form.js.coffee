$(document).ready ->
  $(document).on 'change', '#census_record_page_side', ->
    value = $(this).val()
    $line = $('#census_record_line_number')
    if value is 'A'
      $line.attr('min', 1)
      $line.attr('max', 50)
    else
      $line.attr('min', 51)
      $line.attr('max', 100)

  $(document).on 'change', '#census_record_relation_to_head', ->
    value = $(this).val()
    value = value.replace /\b\w/g, (l) -> l.toUpperCase()
    $(this).val(value)
    if value is 'Head'
      $('input[name="census_record[owned_or_rented]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
      $('input[name="census_record[mortgage]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
      $('input[name="census_record[farm_or_house]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
    else
      $('input[name="census_record[owned_or_rented]"]').prop('checked', no).prop('disabled', yes)
      $('input[name="census_record[mortgage]"]').prop('checked', no).prop('disabled', yes)
      $('input[name="census_record[farm_or_house]"]').prop('checked', no).prop('disabled', yes)

  $(document).on 'change', '#census_record_sex', ->
    value = $(this).val()
    if value is 'M'
      $('#census_record_num_children_born').val(null).prop('disabled', yes)
      $('#census_record_num_children_alive').val(null).prop('disabled', yes)
    else if value is 'F'
      $('#census_record_num_children_born').prop('disabled', no)
      $('#census_record_num_children_alive').prop('disabled', no)

  $(document).on 'change', '#census_record_age', ->
    value = $(this).val()
    if value and parseInt(value) < 10
      $('input[name="census_record[can_read]"]').val(null).prop('disabled', yes)
      $('input[name="census_record[can_write]"]').val(null).prop('disabled', yes)
      $('#census_record_language_spoken').val(null).prop('disabled', yes)
    else
      $('input[name="census_record[can_read]"]').prop('disabled', no)
      $('input[name="census_record[can_write]"]').prop('disabled', no)
      $('#census_record_language_spoken').val('English').prop('disabled', no)

  $(document).on 'change', '#census_record_marital_status', ->
    value = $(this).val()
    if value is 'S' or value is 'D'
      $('#census_record_years_married').val(null).prop('disabled', yes)
    else
      $('#census_record_years_married').val(null).prop('disabled', no)
