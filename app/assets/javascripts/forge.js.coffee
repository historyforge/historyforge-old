#= require 'ng-map.min'
#= require 'wms'
#= require 'forge/services'
#= require 'forge/controllers'

angular
  .module('forge', ['ngMap'])
  .service('BuildingService', forgeApp.BuildingService)
  .service('LayerService', forgeApp.LayerService)
  .controller('MainCtrl', forgeApp.MainController)
  .controller('LayersCtrl', forgeApp.LayersController)
  .controller('ForgeMapCtrl', forgeApp.MapController)
