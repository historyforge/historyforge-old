class Wms::MapController < Wms::BaseController

  def generate_wms

    @map = Map.find(params[:id])
    #status is additional query param to show the unwarped wms
    status = params["STATUS"].to_s.downcase || "unwarped"

    ows.setParameter("COVERAGE", "image")

    rel_url_root =  (ActionController::Base.relative_url_root.blank?)? '' : ActionController::Base.relative_url_root
    map.setMetaData("wms_onlineresource",
      "http://" + request.host_with_port + rel_url_root + "/maps/wms/#{@map.id}")

    if status == "unwarped"
      raster.data = @map.unwarped_filename

    else #show the warped map
      raster.data = @map.warped_filename
    end

    raster.status = Mapscript::MS_ON
    raster.dump = Mapscript::MS_TRUE
    raster.metadata.set('wcs_formats', 'GEOTIFF')
    raster.metadata.set('wms_title', @map.title)
    raster.metadata.set('wms_srs', 'EPSG:4326 EPSG:3857 EPSG:4269 EPSG:900913')
    #raster.debug = Mapscript::MS_TRUE
    raster.setProcessingKey("CLOSE_CONNECTION", "ALWAYS")

    send_map_data map, ows
  end


end
