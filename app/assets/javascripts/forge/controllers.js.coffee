window.forgeApp or= {}

forgeApp.MainController = ($rootScope, $scope) ->
  $scope.viewMode = 'map'
  $scope.setViewMode = (mode) ->
    $scope.viewMode = mode;
    $rootScope.$broadcast 'viewMode:changed', mode

forgeApp.MainController.$inject = ['$rootScope', '$scope']

forgeApp.LayersController = ($rootScope, $scope, BuildingService, LayerService) ->
  $scope.form = {}
  $scope.form.showOnlyMapBuildings = yes
  $scope.form.buildingType = null
  $scope.buildingTypes = window.buildingTypes
  $scope.buildingTypes.unshift id: null, name: 'all buildings'

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

  $scope.googleMapsUrl="https://maps.googleapis.com/maps/api/js?key=#{window.googleApiKey}";
  wmslayer = null

  $rootScope.$on 'layers:selected', (event, layer) ->
    $scope.layer = layer
    NgMap.getMap().then (map) ->
      map.overlayMapTypes.removeAt(0) if map.overlayMapTypes.length > 0
      url = "/layers/#{$scope.layer.id}/wms?"
      fitToBoundingBox(map, $scope.layer.bbox)
      wmslayer = loadWMS map, url

  $rootScope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings

  $rootScope.$on 'viewMode:changed', (event, viewMode) ->
    if $scope.layer
      NgMap.getMap().then (map) ->
        map.hideInfoWindow(currentWindowId) if currentWindowId
        fn = ->
          google.maps.event.trigger(map, "resize")
          $timeout (fitToBoundingBox(map, $scope.layer.bbox)), 100
        $timeout fn, 100
        return

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
    if $scope.viewMode is 'map'
      NgMap.getMap().then (map) =>
        map.hideInfoWindow(currentWindowId) if currentWindowId
        currentWindowId = "building-iw-#{selectedBuilding.id}"
        $scope.currentBuilding = selectedBuilding
        map.showInfoWindow.apply this, [event, currentWindowId] #"building-marker-#{selectedBuilding.id}"
    else if $scope.viewMode is 'list'
      $anchorScroll.yOffset = 100
      $anchorScroll "building-#{selectedBuilding.id}"
    for building in $scope.buildings
      if building.id is selectedBuilding.id
        building.current = yes
      else
        building.current = no
    return

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

forgeApp.BuildingListController = ($rootScope, $scope, BuildingService) ->
  $scope.buildings = BuildingService.buildings
  $scope.currentPage = 1;
  $scope.pageSize = 15;

  $rootScope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings

  return
forgeApp.BuildingListController.$inject = ['$rootScope', '$scope', 'BuildingService']

forgeApp.BuildingController = ($scope, BuildingService, NgMap) ->

  if $scope.building.year_earliest
    $scope.yearBuilt = "Built in #{$scope.building.year_earliest}."
  if $scope.building.year_latest
    $scope.yearDemolished = "Destroyed in #{$scope.building.year_latest}."
  $scope.hasYears = $scope.building.year_earliest or $scope.building.year_latest

  $scope.hasArchitects = $scope.building.architects.length > 0
  if $scope.hasArchitects
    $scope.architectNames = $scope.building.architects.map((item) -> item.name).join(', ')

  $scope.buildingClassFor = () ->
    return if $scope.building?.highlighted then 'highlighted' else ''
  $scope.showBuilding = () ->
    NgMap.getMap().then (map) =>
      point = new google.maps.LatLng parseFloat($scope.building.latitude), parseFloat($scope.building.longitude)
      map.setCenter point
    for building in $scope.$parent.buildings
      building.current = building.id is $scope.building.id
    return

  $scope.highlightBuilding = () ->
    BuildingService.highlight $scope.building.id
  $scope.unhighlightBuilding = () ->
    BuildingService.highlight(null) if $scope.building.highlighted
  return

forgeApp.BuildingController.$inject = ['$scope', 'BuildingService', 'NgMap']
