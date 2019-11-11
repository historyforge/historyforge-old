window.forgeApp or= {}

forgeApp.BuildingService = ($http, $rootScope) ->
  $http.defaults.headers.common.Accept = 'application/json'
  return {
    buildings: null
    meta: null
    load: (form) ->
      params = {}
      if window.forgeSearchParams?.buildings?
        params.s = window.forgeSearchParams.s
      else
        params.s or= {}
        params.s.as_of_year = form.buildingYear if form.buildingYear
        params.s.building_type_id_eq = form.buildingType.id if form.buildingType

        # TODO: allow search of building and people by redoing forgeSearchParams
        if window.forgeSearchParams?.people?
          params.people = window.forgeSearchParams.people
          params.peopleParams = window.forgeSearchParams.s
      params.s.lat_not_null = 1
      params.page = form.page || 1

      $http.get('/buildings.json', params: params).then (response) =>
        @buildings = response.data?.buildings or []
        #@buildings = @buildings.map (building) => building.data.attributes
        @meta = response.data?.meta
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
    loadOne: (building) ->
      condensed = building.residents isnt null
      url = "/buildings/#{building.id}.json"
      params = {}
      params.condensed = true if condensed
      if window.forgeSearchParams?.people?
        params.people = window.forgeSearchParams.people
        params.peopleParams = window.forgeSearchParams.s
      $http.get(url, params: params).then (response) =>
        base = response.data.data.attributes
#        base.census_records = building.residents if condensed
        $rootScope.$broadcast 'building:infoWindow', base
  }

forgeApp.BuildingService.$inject = ['$http', '$rootScope']

forgeApp.LayerService = ($http, $rootScope) ->
  return {
    layers: null
    layerDictionary: {}
    topLayer: null
    bottomLayer: null
    load: ->
      @layers = window.layers or []
      @layerDictionary[layer.id] = layer for layer in @layers
      $rootScope.$broadcast 'layers:updated', @layers

    selectTop: (id) ->
      @topLayer = @getLayerById(id)
      $rootScope.$broadcast 'layers:selected:top', id
    selectBottom: (id) ->
      @bottomLayer = @getLayerById(id)
      $rootScope.$broadcast 'layers:selected:bottom', id
    getLayerById: (id) ->
      @layerDictionary[id]
  }
forgeApp.LayerService.$inject = ['$http', '$rootScope']
