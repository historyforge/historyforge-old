window.forgeApp or= {}

forgeApp.MainController = ($rootScope, $scope) ->

forgeApp.MainController.$inject = ['$rootScope', '$scope']

forgeApp.LayersController = ($rootScope, $scope, BuildingService, LayerService) ->
  $scope.form = {}
  $scope.form.buildingType = null
  $scope.form.buildingYear = null
  $scope.selectedLayers = {}
  $scope.buildingTypes = window.buildingTypes
  $scope.buildingYears = [null, 1900, 1910, 1920, 1930, 1940]
  $scope.buildingTypes.unshift name: 'all buildings'

  $scope.applyFilters = -> BuildingService.load $scope.form
  $scope.toggleLayer = (id) -> LayerService.toggle id

  $scope.$on 'layers:updated', (event, layers) ->
    $scope.layers = layers

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

  $scope.layerIsSelected = (layer) -> !!$scope.selectedLayers(layer.id)

  $scope.$on 'layers:toggled', (event, selectedLayers) ->
    $scope.layers.forEach (layer) ->
      layer.selected = selectedLayers.indexOf(layer.id) > -1
    NgMap.getMap().then (map) ->
      map.overlayMapTypes.forEach (layer, index) ->
        if layer and selectedLayers.indexOf(layer.name) is -1
          map.overlayMapTypes.removeAt(index)
      selectedLayers.forEach (selectedLayer) ->
        visible = []
        map.overlayMapTypes.forEach (layer) ->
          visible.push layer.name
        unless visible.indexOf(selectedLayer) > -1
          thisLayer = loadWMS map, LayerService.getLayerById(selectedLayer), selectedLayer
          $timeout () ->
            jQuery("#layer#{selectedLayer} .layer-slider").slider
                value: 100,
                range: "min",
                slide: (e, ui) ->
                  thisLayer.setOpacity(ui.value / 100)

  mcOptions =
    imagePath: 'https://cdn.rawgit.com/googlemaps/js-marker-clusterer/gh-pages/images/m'
    minimumClusterSize: 10
    maxZoom: 16
  $scope.$on 'buildings:updated', (event, buildings) =>
    $scope.buildings = buildings
    markers = $scope.buildings.map (building) -> $scope.createMarker(building)
    NgMap.getMap().then (map) =>
      @clusterer or= new MarkerClusterer(map, [], mcOptions)
      @clusterer.clearMarkers()
      @clusterer.addMarkers(markers)

  currentMarker = null
  $scope.createMarker = (building) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(building.lat, building.lon)
      icon: $scope.markerIcon(building)
      zIndex: $scope.zIndexFor(building)
    google.maps.event.addListener marker, 'click', () ->
      if currentMarker?
        currentMarker.setIcon $scope.markerIcon(building, false)
      currentMarker = marker
      currentMarker.setIcon $scope.markerIcon(building, true)
      $scope.showBuilding(building)
    google.maps.event.addListener marker, 'mouseover', () -> $scope.highlightBuilding(building)
    marker

  infoWindow = new google.maps.InfoWindow

  $scope.$on 'building:infoWindow', (event, building, e) ->
    $scope.currentBuilding = building
    if currentMarker and building
      NgMap.getMap().then (map) ->
        infoWindow.setContent building.street_address
        infoWindow.open map, currentMarker
    else
      infoWindow.close()
  $scope.markerIcon = (building, highlighted = no) ->
    return {
      path: google.maps.SymbolPath.CIRCLE
      fillColor: if highlighted then 'blue' else 'red'
      fillOpacity: .9
      scale: 6
      strokeColor: '#333'
      strokeWeight: 1
    }

  $scope.zIndexFor = (building) ->
    return if building.highlighted then 100 else 10

  currentWindowId = null
  $scope.showBuilding = (selectedBuilding) ->
    BuildingService.loadOne(selectedBuilding, event)
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

  fitToBoundingBox = (map, bbox) ->
    boxValues = bbox.split(',')
    box = new google.maps.LatLngBounds()
    box.extend new google.maps.LatLng(parseFloat(boxValues[1]), parseFloat(boxValues[0]))
    box.extend new google.maps.LatLng(parseFloat(boxValues[3]), parseFloat(boxValues[2]))
    map.fitBounds(box)

  return
forgeApp.MapController.$inject = ['$rootScope', '$scope', 'NgMap', '$anchorScroll', '$timeout', 'BuildingService', 'LayerService']
