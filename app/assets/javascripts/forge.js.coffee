#= require 'ng-map.min'
#= require 'wms'

forge = {}

forge.BuildingService = ($http, $rootScope) ->
  $http.defaults.headers.common.Accept = 'application/json'
  return {
    buildings: null
    load: (form) ->
      params = lat_not_null: 1
      params.as_of_year = 1910 if form.showOnlyMapBuildings
      params.building_type_id_eq = form.buildingType.id if form.buildingType

      $http.get('/buildings.json', params: params).then (response) =>
        @buildings = response.data?.buildings or []
        $rootScope.$broadcast 'buildings:updated', @buildings
      return
    save: (building) ->
      token = $('meta[name=csrf-token]').attr('content')
      $http.patch("/buildings/#{building.id}",
        authenticity_token: token
        building:
          lat: building.lat
          lon: building.lon
      ).then =>
        for bldg in @buildings
          if bldg.id is building.id
            bldg.lat = building.lat
            bldg.lon = building.lon
        $rootScope.$broadcast 'buildings:updated', @buildings
    highlight: (id) ->
      if id
        building.highlighted = building.id is id for building in @buildings
      else
        building.highlighted = no for building in @buildings
      $rootScope.$broadcast 'building:highlighted', id
  }

forge.BuildingService.$inject = ['$http', '$rootScope']

forge.LayerService = ($http, $rootScope) ->
  $http.defaults.headers.common.Accept = 'application/json'
  return {
    layers: null
    load: ->
      $http.get('/layers.json').then (response) =>
        @layers = response.data?.items or []
        $rootScope.$broadcast 'layers:updated', @layers
  }
forge.LayerService.$inject = ['$http', '$rootScope']

forge.BuildingListController = ($rootScope, $scope, $http, $anchorScroll, BuildingService) ->
  $scope.buildingTypes = window.buildingTypes
  $scope.buildings = []
  $scope.layers = []
  $scope.layer = null
  $scope.form = {}

  $rootScope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings


  $scope.form.showOnlyMapBuildings = yes
  $scope.form.buildingType = null

  $scope.applyFilters = -> BuildingService.load $scope.form

  BuildingService.load $scope.form

  return
forge.BuildingListController.$inject = ['$rootScope', '$scope', '$http', '$anchorScroll', 'BuildingService']


forge.LayersController = ($scope) ->
  $scope.selectLayer = ->
    console.log "Layer selected: ", $scope.layer.name
    $scope.$parent.layer = $scope.layer
    return
  return
forge.LayersController.$inject = ['$scope']

forge.MapController = ($rootScope, $scope, NgMap, $anchorScroll, $timeout, BuildingService, LayerService) ->
  wmslayer = null

  $rootScope.$on 'layers:updated', (event, layers) ->
    $scope.layers = layers
    $scope.layer = layers[0] if $scope.layers.length is 1

  LayerService.load()

  $rootScope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings

  $scope.markerIcon = (building) ->
    return {
      path: google.maps.SymbolPath.CIRCLE
      fillColor: if building.highlighted then 'blue' else 'red'
      fillOpacity: .9
      scale: 6
      strokeColor: '#333'
      strokeWeight: 1
    }

  $scope.zIndexFor = (building) ->
    return if building.highlighted then 100 else 10

  $scope.showBuilding = (event, selectedBuilding) ->
    for building in $scope.buildings
      if building.id is selectedBuilding.id
        $scope.showBuildingResult(building.id)
        building.current = yes
      else
        building.current = no
    return

  $scope.showBuildingResult = (id) ->
    $anchorScroll.yOffset = 100
    $anchorScroll "building-#{id}"

  $scope.highlightBuilding = (event, building) ->
    BuildingService.highlight building.id
  $scope.unhighlightBuilding = (event, building) ->
    BuildingService.highlight(null) if building.highlighted

  dragTimeout = null
  $scope.moveBuilding = (event, building) ->
    point = event.latLng
    building.lat = point.lat()
    building.lon = point.lng()
    saveBuilding = ->
      BuildingService.save(building)
    $timeout.cancel(dragTimeout) if dragTimeout
    dragTimeout = $timeout saveBuilding, 1000
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

  return
forge.MapController.$inject = ['$rootScope', '$scope', 'NgMap', '$anchorScroll', '$timeout', 'BuildingService', 'LayerService']

forge.BuildingController = ($scope, BuildingService) ->
  $scope.buildingClassFor = () ->
    return if $scope.building?.highlighted then 'highlighted' else ''
  $scope.showBuilding = () ->
    for building in $scope.$parent.buildings
      building.current = building.id is $scope.building.id
    return

  $scope.highlightBuilding = () ->
    BuildingService.highlight $scope.building.id
  $scope.unhighlightBuilding = () ->
    BuildingService.highlight(null) if $scope.building.highlighted
  return
forge.BuildingController.$inject = ['$scope', 'BuildingService']



angular
  .module('forge', ['ngMap'])
  .service('BuildingService', forge.BuildingService)
  .service('LayerService', forge.LayerService)
  .controller('BuildingListCtrl', forge.BuildingListController)
  .controller('LayersCtrl', forge.LayersController)
  .controller('ForgeMapCtrl', forge.MapController)
  .controller('BuildingCtrl', forge.BuildingController)
