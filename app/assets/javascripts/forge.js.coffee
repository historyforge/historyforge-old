#= require 'ng-map.min'

forge = {}

forge.ForgeController = ($scope, $http) ->
  $scope.buildings = []
  $scope.building  = null
  $scope.layers = []
  $scope.layer = null
  $http.get('/layers.json').then (response) ->
    $scope.layers = response.data?.items or []
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
  kmlLayer = null
  $scope.showBuilding = (event, building) ->
    console.log building
    $scope.$parent.building = building
    return
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
forge.MapController.$inject = ['$scope', 'NgMap']

forge.BuildingController = ($scope) -> return
forge.BuildingController.$inject = ['$scope']



angular
  .module('forge', ['ngMap'])
  .controller('ForgeCtrl', forge.ForgeController)
  .controller('LayersCtrl', forge.LayersController)
  .controller('ForgeMapCtrl', forge.MapController)
  .controller('BuildingCtrl', forge.BuildingController)
