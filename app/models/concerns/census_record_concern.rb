module CensusRecordConcern
  extend ActiveSupport::Concern
  included do

    include Moderation
    belongs_to :building

    attr_accessor :ensure_building
    before_save :ensure_housing

    validates :first_name, :last_name, :family_id, :dwelling_number, :relation_to_head,
              :sex, :race, :age, :marital_status,
              :page_number, :page_side, :line_number, :county, :city, :state, :ward, :enum_dist,
              presence: true

    validate :dont_add_same_person, on: :create

    def dont_add_same_person
      if new_record? && likely_matches?
        errors.add :last_name, 'A person with the same street number, street name, last name, and first name is already in the system.'
      end
    end

    def likely_matches?
      self.class.ransack(
        street_house_number_eq: street_house_number,
        street_name_eq: street_name,
        last_name_eq: last_name,
        first_name_eq: first_name,
        age_eq: age
      ).result.count > 0
    end

    def name
      [first_name, middle_name, last_name].select(&:present?).join(' ')
    end

    def street_address
      [street_house_number, street_prefix, street_name, street_suffix].join(' ')
    end

    def fellows
      @fellows ||= self.class.where('id<>?', id)
                       .ransack(street_house_number_eq: street_house_number,
                                street_prefix_eq: street_prefix,
                                street_name_eq: street_name,
                                dwelling_number_eq: dwelling_number,
                                family_id_eq: family_id).result
    end

    def buildings_on_street
      return [] unless (street_name.present? && city.present?)
      search_streets = [street_name, convert_street_name]
      @buildings_on_street ||= Building.where(address_street_name: search_streets, city: city).order(:address_house_number)
    end

    def matching_building(my_street_name = nil)
      my_street_name ||= convert_street_name
      @matching_building ||= Building.where(address_house_number: street_house_number,
                                            address_street_prefix: street_prefix,
                                            address_street_name: my_street_name,
                                            city: city).first
    end

    def ensure_housing
      building_from_address if building_id.blank? && ensure_building == '1' && street_name.present? && city.present? && street_house_number.present?
    end

    # TODO: street name conversions need to be backed by database, moved into own class
    def convert_street_name
      if street_name == 'Mill'
        'Court'
      elsif street_name == 'Boulevard' || street_name == 'Glenwood'
        'Old Taughannock'
      elsif street_name == 'Humboldt'
        'Floral'
      else
        street_name
      end
    end

    def convert_street_suffix
      if street_name == 'Boulevard' || street_name == 'Glenwood'
        'Blvd'
      elsif street_name == 'Humboldt'
        'Avenue'
      end
    end

    def building_from_address
      my_street_name = convert_street_name
      my_street_suffix = convert_street_suffix
      self.building ||= matching_building(my_street_name) || Building.create(
        name: "#{street_name} #{street_suffix} - #{street_prefix} - ##{street_house_number}",
        address_house_number: street_house_number,
        address_street_prefix: street_prefix,
        address_street_name: my_street_name,
        address_street_suffix: my_street_suffix,
        city: city,
        state: state,
        building_type: BuildingType.where(name: 'residence').first
      )
    end

    def year
      raise 'Need a year!'
    end

  end
end
