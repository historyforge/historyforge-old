module PhotographsHelper
  def thumb_for(photo)
    return unless photo.file.attached?
    image_tag photo.file.variant(resize: '300x300>'), class: 'img img-thumbnail'
  end
end