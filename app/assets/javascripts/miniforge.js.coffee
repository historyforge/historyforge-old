#= require 'ng-map.min'
#= require 'wms'

MiniMapController = ($scope, NgMap, $rootScope, $http) ->
  $scope.layer = window.layer
  $scope.buildings = window.buildings
  $scope.googleMapsUrl="https://maps.googleapis.com/maps/api/js?key=#{window.googleApiKey}";
  wmslayer = null
  highlighted = null

  NgMap.getMap().then (map) ->
    map.overlayMapTypes.removeAt(0) if map.overlayMapTypes.length > 0
    wmslayer = loadWMS map, $scope.layer.id, 'top'

  $scope.markerIcon = (building) ->
    return {
      path: google.maps.SymbolPath.CIRCLE
      fillColor: if highlighted is building.id then 'blue' else 'red'
      fillOpacity: .9
      scale: 6
      strokeColor: '#333'
      strokeWeight: 1
    }

  $scope.thisMarkerIcon =
    path: google.maps.SymbolPath.CIRCLE
    fillColor: 'green'
    fillOpacity: .9
    scale: 10
    strokeColor: '#333'
    strokeWeight: 1

  $scope.zIndexFor = (building) ->
    return if building.highlighted then 100 else 10

  $scope.highlightBuilding = (event, building) ->
    $rootScope.$broadcast 'building:highlighted', building.id
  $scope.unhighlightBuilding = (event, building) ->
    $rootScope.$broadcast 'building:highlighted'

  $rootScope.$on 'building:highlighted', (event, id) ->
    highlighted = id

  $scope.moveBuilding = (event, building) ->
    point = event.latLng
    token = $('meta[name=csrf-token]').attr('content')
    $http.patch document.location.pathname,
      authenticity_token: token
      building:
        lat: point.lat()
        lon: point.lng()

    return


  jQuery("#layer-slider").slider
      value: 100,
      range: "min",
      slide: (e, ui) ->
        wmslayer.setOpacity(ui.value / 100)


MiniMapController.$inject = ['$scope', 'NgMap', '$rootScope', '$http']

MiniBuildingListController = ($scope) ->
  $scope.buildings = window.buildings
  # # for building in window.buildings
  # #   $scope.buildings.push building.building
  # return
MiniBuildingListController.$inject = ['$scope']

MiniBuildingController = ($scope, $rootScope) ->
  $scope.buildingClass = null
  $scope.highlightBuilding = (event) ->
    $rootScope.$broadcast 'building:highlighted', $scope.building.id
  $scope.unhighlightBuilding = (event, building) ->
    $rootScope.$broadcast 'building:highlighted'
  $rootScope.$on 'building:highlighted', (event, id) ->
    if id is $scope.building.id
      $scope.buildingClass = 'highlighted'
    else
      $scope.buildingClass = null

MiniBuildingController.$inject = ['$scope', '$rootScope']

angular
  .module('miniforge', ['ngMap'])
  .controller('MiniMapCtrl', MiniMapController)
  .controller('MiniBuildingCtrl', MiniBuildingController)
  .controller('MiniBuildingListCtrl', MiniBuildingListController)
