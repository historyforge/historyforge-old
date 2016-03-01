class Photo < ActiveRecord::Base

  belongs_to :building

  acts_as_list scope: :building_id

  has_attached_file :photo,
    :url => '/:attachment/:id/:style/:basename.:extension',
    :default_url => "/assets/missing.png"
  validates_attachment_size(:photo, :less_than => MAX_ATTACHMENT_SIZE) if defined?(MAX_ATTACHMENT_SIZE)
  #attr_protected :upload_file_name, :upload_content_type, :upload_size
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :photo, presence: true

  def full_caption
    items = [caption]
    items << "Taken in #{year_taken}." if year_taken?
    items.compact.join(' ')
  end
end
