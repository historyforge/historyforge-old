window.forgeApp or= {}

forgeApp.BuildingService = ($http, $rootScope) ->
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

forgeApp.BuildingService.$inject = ['$http', '$rootScope']

forgeApp.LayerService = ($http, $rootScope) ->
  $http.defaults.headers.common.Accept = 'application/json'
  return {
    layers: null
    layer: null
    load: ->
      $http.get('/layers.json').then (response) =>
        @layers = response.data?.items or []
        $rootScope.$broadcast 'layers:updated', @layers
        if @layers.length is 1
          @select @layers[0]
    select: (layer) ->
      @layer = layer
      $rootScope.$broadcast 'layers:selected', @layer
  }
forgeApp.LayerService.$inject = ['$http', '$rootScope']
