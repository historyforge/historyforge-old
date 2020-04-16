$(document).ready(function() {
  $('#search-people-input').each(function() {
    $(this).autocomplete({ source: "/search/people", select: (event, ui) => {
      const url = ui.item.url
      document.location = url
    }}).autocomplete( "instance" )._renderItem = function( ul, item ) {
      return $( "<li>" )
        .append( `<div>${item.name} (${item.age})<br>${item.address}</div>` )
        .appendTo( ul );
    };
  })
  $('#search-buildings-input').each(function() {
    $(this).autocomplete({ source: "/search/buildings", select: (event, ui) => {
      const url = ui.item.url
      document.location = url
    }}).autocomplete( "instance" )._renderItem = function( ul, item ) {
      return $( "<li>" )
        .append( `<div>${item.name}</div>` )
        .appendTo( ul );
    };
  })
})