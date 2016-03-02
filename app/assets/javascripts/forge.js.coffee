#= require 'ng-map.min'

angular.module 'forge', ['ngMap']

.controller 'ForgeCtrl', ($scope, $http) ->
  $scope.buildings = []
  $scope.building  = null
  $scope.layers = []
  $scope.layer = null
  $http.get('/layers.json').then (response) ->
    $scope.layers = response.data?.items or []
  $http.get('/buildings.json').then (response) ->
    $scope.buildings = response.data?.buildings or []
  return

.controller 'LayersCtrl', ($scope) ->
  $scope.selectLayer = ->
    console.log "Layer selected: ", $scope.layer.name
    $scope.$parent.layer = $scope.layer
    return
  return

.controller 'ForgeMapCtrl', ($scope, NgMap) ->
  kmlLayer = null
  $scope.showBuilding = (event, building) ->
    console.log building
    $scope.$parent.building = building
    return
  # $scope.$watch 'layer', (newValue, oldValue) ->
  #   kmlLayer?.setMap(null)
  #   if newValue
  #     NgMap.getMap().then (map) ->
  #       kml_url = "http://historyforge.dev/layers/#{newValue.id}.kml"
  #       kml_options =
  #         suppressInfoWindows: yes
  #         preserveViewport: no
  #         map: map
  #       kmlLayer = new google.maps.KmlLayer kml_url, kml_options
  #       return
  $scope.$watch 'buildings', (newValue, oldValue) ->
    return unless newValue
    if newValue.length is 1
      building = newValue[0]
      if building.latitude
        latlng = new google.maps.LatLng(building.latitude, building.longitude)
        NgMap.getMap().then (map) ->
          map.setCenter latlng
    else
      bounds = new google.maps.LatLngBounds()
      for building in newValue
        if building.latitude
          latlng = new google.maps.LatLng(building.latitude, building.longitude)
        bounds.extend latlng
      NgMap.getMap().then (map) ->
        map.setCenter bounds.getCenter()
        map.fitBounds bounds
    return

  return

.controller 'BuildingCtrl', ($scope) ->
