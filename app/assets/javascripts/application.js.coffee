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
