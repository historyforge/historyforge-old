require 'mapscript'
require 'digest/sha1'

class Wms::BaseController < ActionController::Base
  include Mapscript

  caches_action :wms,
                unless: -> { request.params["request"] == "GetCapabilities" },
                :cache_path => Proc.new { |c|
                  string =  c.params.to_s
                  {:status => c.params["status"] || c.params["STATUS"], :tag => Digest::SHA1.hexdigest(string)}
                }

  caches_action :tile, :cache_path => Proc.new { |c|
    string =  c.params.to_s
    {:tag => Digest::SHA1.hexdigest(string)}
  }

  def tile
    send_wms *generate_tile
  end

  def wms
    send_wms *generate_wms
  end

  def send_wms(content_type, result_data)
    if content_type
      send_data result_data, type: content_type, disposition: "inline"
    else
      render plain: 'File not found', status: 404
    end
  end

  private

  def generate_wms
    raise "You need to implement wms action in subclass."
  end

  def generate_tile
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
    map.OWSDispatch(ows)
    content_type = Mapscript.msIO_stripStdoutBufferContentType || "text/plain"
    result_data = Mapscript.msIO_getStdoutBufferBytes
    [content_type, result_data]
  # rescue Mapscript::MapserverError
  #   [nil, nil]
  ensure
    Mapscript.msIO_resetHandlers
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
      @map2 = Mapscript::MapObj.new(Rails.root.join('lib', 'mapserver', 'wms.map').to_s)
      projfile = Rails.root.join('lib', 'proj').to_s
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
