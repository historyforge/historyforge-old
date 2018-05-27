class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :confirmable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable #, :encryptable #,
    # :omniauthable, :omniauth_providers => [ :osm, :mediawiki, :github]
  has_many :permissions
  has_many :roles, :through => :permissions

  has_many :my_maps, :dependent => :destroy
  has_many :maps, -> { distinct }, :through => :my_maps

  has_many :layers, :dependent => :destroy

  validates_presence_of    :login
  validates_length_of      :login,    :within => 3..40
  validates_uniqueness_of  :login, :scope => :email, :case_sensitive => false

  after_destroy :delete_maps

  def name
    login
  end

  def has_role?(name)
    self.roles.find_by_name(name) ? true : false
  end

  def own_maps
    Map.where(["owner_id = ?", self.id])
  end

  def own_this_map?(map_id)
    Map.exists?(:id => map_id.to_i, :owner_id => self.id)
  end

  def own_this_layer?(layer_id)
    Layer.exists?(:id => layer_id.to_i, :user_id => self.id)
  end

  #Called by Devise
  #Method checks to see if the user is enabled (it will therefore not allow a user who is disabled to log in)
  def active_for_authentication?
    super and self.enabled?
  end

  protected

  #called after the user has been destroyed
  #delete all user maps
  def delete_maps
    own_maps.each do | map |
      logger.debug "deleting map #{map.inspect}"
      map.destroy
    end
  end


end
