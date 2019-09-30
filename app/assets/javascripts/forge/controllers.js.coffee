window.forgeApp or= {}

forgeApp.MainController = ($rootScope, $scope) ->
  $scope.viewMode = 'map'
  $scope.setViewMode = (mode) ->
    $scope.viewMode = mode;
    $rootScope.$broadcast 'viewMode:changed', mode

forgeApp.MainController.$inject = ['$rootScope', '$scope']

forgeApp.LayersController = ($rootScope, $scope, BuildingService, LayerService) ->
  $scope.form = {}
  $scope.form.buildingType = null
  $scope.form.buildingYear = null
  $scope.selectedLayers = top: null, bottom: null
  $scope.buildingTypes = window.buildingTypes
  $scope.buildingYears = [null, 1900, 1910, 1920, 1930]
  $scope.buildingTypes.unshift name: 'all buildings'

  $scope.applyFilters = -> BuildingService.load $scope.form
  $scope.selectLayer  = (id) -> LayerService.selectTop id
  $scope.selectLayer2  = (id) -> LayerService.selectBottom id

  $scope.$on 'layers:updated', (event, layers) ->
    if layers[0].id isnt null
      layers.unshift id: null, name: 'None'
    $scope.layers = layers

  $scope.$on 'layers:selected:top', (event, layer) ->
    $scope.selectedLayers.top = layer

  $scope.$on 'layers:selected:bottom', (event, layer2) ->
    $scope.selectedLayers.bottom = layer2

  $scope.$on 'buildings:updated', (event) ->
    $scope.meta = BuildingService.meta

  $scope.setPage = (page) =>
    $scope.form.page = page
    BuildingService.load $scope.form

  BuildingService.load $scope.form
  LayerService.load()

  return

forgeApp.LayersController.$inject = ['$rootScope', '$scope', 'BuildingService', 'LayerService']

forgeApp.MapController = ($rootScope, $scope, NgMap, $anchorScroll, $timeout, BuildingService, LayerService) ->

  $scope.googleMapsUrl="https://maps.googleapis.com/maps/api/js?key=#{window.googleApiKey}";
  wmsLayerTop = null
  wmsLayerBottom = null

  $scope.selectedLayers = top: null, bottom: null

  $scope.$on 'layers:selected:top', (event, id) ->
    $scope.selectedLayers.top = id
    NgMap.getMap().then (map) ->
      if wmsLayerTop #and map.overlayMapTypes.getLength() > 0
        map.overlayMapTypes.forEach (layer, index) ->
          map.overlayMapTypes.removeAt(index) if layer.name is wmsLayerTop.name
      if id
        wmsLayerTop = loadWMS map, id, 'top'
        # debugger
        # map.overlayMapTypes.push wmsLayerTop
        jQuery(".layer-slider-top").slider
            value: 100,
            range: "min",
            slide: (e, ui) ->
              wmsLayerTop.setOpacity(ui.value / 100)
      else
        wmsLayerTop = null
  $scope.$on 'layers:selected:bottom', (event, id) ->
    $scope.selectedLayers.bottom = id
    NgMap.getMap().then (map) ->
      if wmsLayerBottom and map.overlayMapTypes.getLength() > 0
        map.overlayMapTypes.forEach (layer, index) ->
          map.overlayMapTypes.removeAt(index) if layer.name is wmsLayerBottom.name
      if id
        wmsLayerBottom = loadWMS map, id, 'bottom'
        # map.overlayMapTypes.insertAt(0, wmsLayerBottom)
        jQuery(".layer-slider-bottom").slider
            value: 100,
            range: "min",
            slide: (e, ui) ->
              wmsLayerBottom.setOpacity(ui.value / 100)
      else
        wmsLayerBottom = null

  $scope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings
#    $scope.meta = BuildingService.meta
    markers = $scope.buildings.map (building) -> $scope.createMarker(building)
    NgMap.getMap().then (map) ->
      mcOptions =
        imagePath: 'https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m'
        minimumClusterSize: 10
        maxZoom: 16
      return new MarkerClusterer(map, markers, mcOptions)

  $scope.createMarker = (building) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(building.lat, building.lon)
      icon: $scope.markerIcon(building)
      zIndex: $scope.zIndexFor(building)
    google.maps.event.addListener marker, 'click', () -> $scope.showBuilding(building)
    google.maps.event.addListener marker, 'mouseover', () -> $scope.highlightBuilding(building)
    marker

  $scope.$on 'building:infoWindow', (event, building, e) ->
    $scope.currentBuilding = building

  $scope.$on 'viewMode:changed', (event, viewMode) ->
    if $scope.selectedLayers.top or $scope.selectLayers.bottom
      NgMap.getMap().then (map) ->
        fn = ->
          map.hideInfoWindow('building-iw')
          google.maps.event.trigger(map, "resize")
          $('#forge-right-col').removeAttr('style')
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
  $scope.showBuilding = (selectedBuilding) ->
    if $scope.viewMode is 'map'
      BuildingService.loadOne(selectedBuilding, event)
    else if $scope.viewMode is 'list'
      $anchorScroll.yOffset = 100
      $anchorScroll "building-#{selectedBuilding.id}"
    for building in $scope.buildings
      if building.id is selectedBuilding.id
        building.current = yes
      else
        building.current = no
    return

  $scope.hideBuilding = ->
    $scope.currentBuilding = null

  $scope.highlightBuilding = (building) ->
    BuildingService.highlight building.id
  $scope.unhighlightBuilding = (building) ->
    BuildingService.highlight(null) if building.highlighted

  jQuery('#forge-right-col').draggable()

  fitToBoundingBox = (map, bbox) ->
    boxValues = bbox.split(',')
    box = new google.maps.LatLngBounds()
    box.extend new google.maps.LatLng(parseFloat(boxValues[1]), parseFloat(boxValues[0]))
    box.extend new google.maps.LatLng(parseFloat(boxValues[3]), parseFloat(boxValues[2]))
    console.log 'center map to layer bounds!'
    map.fitBounds(box)

  return
forgeApp.MapController.$inject = ['$rootScope', '$scope', 'NgMap', '$anchorScroll', '$timeout', 'BuildingService', 'LayerService']

forgeApp.BuildingListController = ($rootScope, $scope, BuildingService) ->
  $scope.buildings = BuildingService.buildings
  $scope.currentPage = 1;
  $scope.pageSize = 15;

  $scope.$on 'buildings:updated', (event, buildings) ->
    $scope.buildings = buildings

  return
forgeApp.BuildingListController.$inject = ['$rootScope', '$scope', 'BuildingService']

forgeApp.BuildingController = ($scope, BuildingService, NgMap) ->

  if $scope.building.year_earliest
    $scope.yearBuilt = "Built in #{$scope.building.year_earliest}."
  if $scope.building.year_latest
    $scope.yearDemolished = "Destroyed in #{$scope.building.year_latest}."
  $scope.hasYears = $scope.building.data.attributes.year_earliest or $scope.building.data.attributes.year_latest

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
