#= require 'ng-map.min'
#= require 'wms'
#= require 'dir-pagination'
#= require 'forge/services'
#= require 'forge/controllers'

angular
  .module('forge', ['ngMap', 'angularUtils.directives.dirPagination'])
  .service('BuildingService', forgeApp.BuildingService)
  .service('LayerService', forgeApp.LayerService)
  .controller('BuildingListCtrl', forgeApp.BuildingListController)
  .controller('LayersCtrl', forgeApp.LayersController)
  .controller('ForgeMapCtrl', forgeApp.MapController)
  .controller('BuildingCtrl', forgeApp.BuildingController)
