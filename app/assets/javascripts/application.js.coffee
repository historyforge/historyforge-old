#= require jquery.ui.all
#= require jquery_ujs

#= require jquery-bramus-progressbar/jquery-bramus-progressbar
#= require general
#= require jquery.history
#= require jquery-warper
#= require layers
#= require unwarped
#= require SelectFeatureNoClick
#= require querystring
#= require alertify.min

querystring = require('querystring-component')

pageLoad = ->
  window.alerts or= []
  window.alertifyInit()
  alertify.set delay: 10000
  for alert in window.alerts
    alertify[alert[0]](alert[1])
  window.alerts = []
  return

$(document).ready ->
  window.alertifyInit = alertify.init
  do pageLoad


$(document).on 'blur', '#city, #street_name', ->
  city = $('#city').val()
  city = null if city is ''
  street = $('#street_name').val()
  street = null if street is ''
  if city and street
    params = city: city, street: street
    $.getJSON '/census/1910/building_autocomplete', params, (json) ->
      building = $('#building_id')
      current_value = building.val()
      html = '<option value="">Select a building</option>'
      for item in json
        html += "<option value=\"#{item.id}\">#{item.name}</option>"
      building.html html
      building.val current_value
