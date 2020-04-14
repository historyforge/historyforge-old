$(document).ready(function() {
  $('#search-people-input').on('keyup', function(e) {
    if (e.keyCode === 13) {
      e.stopPropagation()
    }
    const input = e.target
    const value = input.value
    if (value.length > 1) {
      $('#search-people-results').load('/search/people?q=' + value)
    }
  })
  $('#search-buildings-input').on('keyup', function(e) {
    if (e.keyCode === 13) {
      e.stopPropagation()
    }
    const input = e.target
    const value = input.value
    if (value.length > 1) {
      $('#search-buildings-results').load('/search/buildings?q=' + value)
    }
  })
})