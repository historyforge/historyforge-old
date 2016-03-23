class Wms::BaseController < ActionController::Metal

  require 'mapscript'
  include Mapscript
  include ActionController::RackDelegation
  include AbstractController::Rendering
  include ActionController::DataStreaming

  private

  def tile
    x = params[:x].to_i
    y = params[:y].to_i
    z = params[:z].to_i
    #for Google/OSM tile scheme we need to alter the y:
    y = ((2**z)-y-1)
    #calculate the bbox
    params[:bbox] = get_tile_bbox(x,y,z)
    #build up the other params
    params[:status] = "warped"
    params[:format] = "image/png"
    params[:service] = "WMS"
    params[:version] = "1.1.1"
    params[:request] = "GetMap"
    params[:srs] = "EPSG:900913"
    params[:width] = "256"
    params[:height] = "256"
    wms
  end

  # tile utility methods. calculates the bounding box for a given TMS tile.
  # Based on http://www.maptiler.org/google-maps-coordinates-tile-bounds-projection/
  # GDAL2Tiles, Google Summer of Code 2007 & 2008
  # by  Klokan Petr Pridal
  def get_tile_bbox(x,y,z)
    min_x, min_y = get_merc_coords(x * 256, y * 256, z)
    max_x, max_y = get_merc_coords( (x + 1) * 256, (y + 1) * 256, z )
    return "#{min_x},#{min_y},#{max_x},#{max_y}"
  end

  def get_merc_coords(x,y,z)
    resolution = (2 * Math::PI * 6378137 / 256) / (2 ** z)
    merc_x = (x * resolution -2 * Math::PI  * 6378137 / 2.0)
    merc_y = (y * resolution - 2 * Math::PI  * 6378137 / 2.0)
    return merc_x, merc_y
  end

  def send_map_data(map, ows)
    Mapscript::msIO_installStdoutToBuffer
    result = map.OWSDispatch(ows)
    content_type = Mapscript::msIO_stripStdoutBufferContentType || "text/plain"
    result_data = Mapscript::msIO_getStdoutBufferBytes

    send_data result_data, :type => content_type, :disposition => "inline"
    Mapscript::msIO_resetHandlers
  end

  def ows
    @ows || begin
      @ows = Mapscript::OWSRequest.new

      ok_params = Hash.new
      # params.each {|k,v| k.upcase! } frozen string error
      params.each {|k,v| ok_params[k.upcase] = v }
      [:request, :version, :transparency, :service, :srs, :width, :height, :bbox, :format, :srs].each do |key|
        @ows.setParameter(key.to_s, ok_params[key.to_s.upcase]) unless ok_params[key.to_s.upcase].nil?
      end

      @ows.setParameter("VeRsIoN","1.1.1")
      @ows.setParameter("STYLES", "")
      @ows.setParameter("LAYERS", "image")
      @ows
    end
  end

  def map
    @map2 || begin
      @map2 = Mapscript::MapObj.new(File.join(Rails.root, '/lib/mapserver/wms.map'))
      projfile = File.join(Rails.root, '/lib/proj')
      @map2.setConfigOption("PROJ_LIB", projfile)
      @map2.applyConfigOptions
      @map2
    end
  end

  def raster
    @raster || begin
      @raster = Mapscript::LayerObj.new(map)
      @raster.name = "image"
      @raster.type =  Mapscript::MS_LAYER_RASTER
      @raster.addProcessing("RESAMPLE=BILINEAR")
      @raster
    end
  end




end