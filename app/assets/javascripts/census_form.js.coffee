$(document).ready ->
  $('form.edit_census1910_record, form.new_census1910_record').each ->

    $('#census1910_record_page_side').on 'change', ->
      value = $(this).val()
      $line = $('#census1910_record_line_number')
      if value is 'A'
        $line.attr('min', 1)
        $line.attr('max', 50)
      else
        $line.attr('min', 51)
        $line.attr('max', 100)

    $('#census1910_record_relation_to_head').on 'change', ->
      value = $(this).val()
      value = value.replace /\b\w/g, (l) -> l.toUpperCase()
      $(this).val(value)
      if value is 'Head'
        $('input[name="census1910_record[owned_or_rented]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
        $('input[name="census1910_record[mortgage]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
        $('input[name="census1910_record[farm_or_house]"]').prop('disabled', no).filter('[value=nil]').prop('checked', yes)
      else
        $('input[name="census1910_record[owned_or_rented]"]').prop('checked', no).prop('disabled', yes)
        $('input[name="census1910_record[mortgage]"]').prop('checked', no).prop('disabled', yes)
        $('input[name="census1910_record[farm_or_house]"]').prop('checked', no).prop('disabled', yes)

    $('#census1910_record_sex').on 'change', ->
      value = $(this).val()
      if value is 'M'
        $('#census1910_record_num_children_born').val(null).prop('disabled', yes)
        $('#census1910_record_num_children_alive').val(null).prop('disabled', yes)
      else if value is 'F'
        $('#census1910_record_num_children_born').prop('disabled', no)
        $('#census1910_record_num_children_alive').prop('disabled', no)

    $('#census1910_record_age').on 'change', ->
      value = $(this).val()
      if value and parseInt(value) < 10
        $('input[name="census1910_record[can_read]"]').val(null).prop('disabled', yes)
        $('input[name="census1910_record[can_write]"]').val(null).prop('disabled', yes)
        $('#census1910_record_language_spoken').val(null).prop('disabled', yes)
      else
        $('input[name="census1910_record[can_read]"]').prop('disabled', no)
        $('input[name="census1910_record[can_write]"]').prop('disabled', no)
        $('#census1910_record_language_spoken').val('English').prop('disabled', no)

    $('#census1910_record_marital_status').on 'change', ->
      value = $(this).val()
      if value is 'S' or value is 'D'
        $('#census1910_record_years_married').val(null).prop('disabled', yes)
      else
        $('#census1910_record_years_married').val(null).prop('disabled', no)


    # $('#census1910_record_page_side').trigger 'change'
    # $('#census1910_record_sex').trigger 'change'
    # $('#census1910_record_age').trigger 'change'
    # $('#census1910_record_marital_status').trigger 'change'
    # $('#census1910_record_relation_to_head').trigger 'change'
