#= require jquery.treeTable.min
$(document).ready ->
  $('#menu-table').draggableTable()
  $('#menu-links-tree').submit ->
    position = 1
    last_parent = {}
    last_indentation = 0
    last_item = null
    $('#menu-table tbody tr').each ->
      $(this).find('input.position').val position++
      indentation = $(this).find('.indentation').size() - 1
      if indentation is 0
        last_parent[1] = $(this).find('input.id').val()
        $(this).find('input.parent_id').val null
      else if indentation > last_indentation
        last_parent[indentation] = last_item
        $(this).find('input.parent_id').val last_item
      else
        $(this).find('input.parent_id').val last_parent[indentation]

      last_item = $(this).find('input.id').val()
      last_indentation = indentation
