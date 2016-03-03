#= require 'ng-map.min'
#= require 'wms'

forge = {}

forge.ForgeController = ($scope, $http) ->
  $scope.buildings = []
  $scope.building  = null
  $scope.layers = []
  $scope.layer = null
  $http.get('/layers.json').then (response) ->
    $scope.layers = response.data?.items or []
    $scope.layer = $scope.layers[0] if $scope.layers.length is 1
  $http.get('/buildings.json').then (response) ->
    $scope.buildings = response.data?.buildings or []
  return
forge.ForgeController.$inject = ['$scope', '$http']


forge.LayersController = ($scope) ->
  $scope.selectLayer = ->
    console.log "Layer selected: ", $scope.layer.name
    $scope.$parent.layer = $scope.layer
    return
  return
forge.LayersController.$inject = ['$scope']

forge.MapController = ($scope, NgMap) ->
  wmslayer = null
  $scope.markerIcon =
    path: google.maps.SymbolPath.CIRCLE,
    fillColor: 'red',
    fillOpacity: .9,
    scale: 6,
    strokeColor: '#333',
    strokeWeight: 1

  $scope.showBuilding = (event, building) ->
    $scope.$parent.building = building
    return

  jQuery("#layer-slider").slider
      value: 100,
      range: "min",
      slide: (e, ui) ->
        wmslayer.setOpacity(ui.value / 100)

  $scope.$watch 'layer', (newValue, oldValue) ->
    if newValue
      NgMap.getMap().then (map) ->
        map.overlayMapTypes.removeAt(0) if map.overlayMapTypes.length > 0
        url = "/layers/#{newValue.id}/wms?"
        fitToBoundingBox(map, newValue.bbox)
        wmslayer = loadWMS map, url

  fitToBoundingBox = (map, bbox) ->
    boxValues = bbox.split(',')
    box = new google.maps.LatLngBounds()
    box.extend new google.maps.LatLng(parseFloat(boxValues[1]), parseFloat(boxValues[0]))
    box.extend new google.maps.LatLng(parseFloat(boxValues[3]), parseFloat(boxValues[2]))
    console.log 'center map to layer bounds!'
    map.setCenter box.getCenter()
    map.fitBounds(box)

  # $scope.$watch 'buildings', (newValue, oldValue) ->
  #   return unless newValue
  #   if newValue.length is 1
  #     building = newValue[0]
  #     if building.latitude
  #       latlng = new google.maps.LatLng(building.latitude, building.longitude)
  #       NgMap.getMap().then (map) ->
  #         map.setCenter latlng
  #   else
  #     bounds = new google.maps.LatLngBounds()
  #     for building in newValue
  #       if building.latitude
  #         latlng = new google.maps.LatLng(building.latitude, building.longitude)
  #       bounds.extend latlng
  #     unless $scope.layer
  #       console.log $scope.layer
  #       NgMap.getMap().then (map) ->
  #         console.log 'center map to building bounds!'
  #         map.setCenter bounds.getCenter()
  #         map.fitBounds bounds
  #   return

  return
forge.MapController.$inject = ['$scope', 'NgMap']

forge.BuildingController = ($scope) -> return
forge.BuildingController.$inject = ['$scope']



angular
  .module('forge', ['ngMap'])
  .controller('ForgeCtrl', forge.ForgeController)
  .controller('LayersCtrl', forge.LayersController)
  .controller('ForgeMapCtrl', forge.MapController)
  .controller('BuildingCtrl', forge.BuildingController)
