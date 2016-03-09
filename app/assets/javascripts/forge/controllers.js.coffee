window.forgeApp or= {}

forgeApp.BuildingListController = ($rootScope, $scope, $http, $anchorScroll) ->
  $scope.buildings = []
  $scope.currentPage = 1;
  $scope.pageSize = 15;

  $rootScope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings

  return
forgeApp.BuildingListController.$inject = ['$rootScope', '$scope', '$http', '$anchorScroll']


forgeApp.LayersController = ($rootScope, $scope, BuildingService, LayerService) ->
  $scope.form = {}
  $scope.form.showOnlyMapBuildings = yes
  $scope.form.buildingType = null
  $scope.buildingTypes = window.buildingTypes

  $scope.applyFilters = -> BuildingService.load $scope.form
  $scope.selectLayer  = -> LayerService.select $scope.layer

  $rootScope.$on 'layers:updated', (event, layers) ->
    $scope.layers = layers

  $rootScope.$on 'layers:selected', (event, layer) ->
    $scope.layer = layer


  BuildingService.load $scope.form
  LayerService.load()

  return

forgeApp.LayersController.$inject = ['$rootScope', '$scope', 'BuildingService', 'LayerService']

forgeApp.MapController = ($rootScope, $scope, NgMap, $anchorScroll, $timeout, BuildingService, LayerService) ->

  wmslayer = null

  $rootScope.$on 'layers:selected', (event, layer) ->
    $scope.layer = layer

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

  currentWindowId = null
  $scope.showBuilding = (event, selectedBuilding) ->
    NgMap.getMap().then (map) =>
      map.hideInfoWindow(currentWindowId) if currentWindowId
      currentWindowId = "building-iw-#{selectedBuilding.id}"
      $scope.currentBuilding = selectedBuilding
      map.showInfoWindow.apply this, [event, currentWindowId] #"building-marker-#{selectedBuilding.id}"
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
forgeApp.MapController.$inject = ['$rootScope', '$scope', 'NgMap', '$anchorScroll', '$timeout', 'BuildingService', 'LayerService']

forgeApp.BuildingController = ($scope, BuildingService) ->
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
forgeApp.BuildingController.$inject = ['$scope', 'BuildingService']
