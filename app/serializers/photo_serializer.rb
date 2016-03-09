class PhotoSerializer < ActiveModel::Serializer

  attributes :id, :caption, :url

  def url
    object.photo.url
  end

end
