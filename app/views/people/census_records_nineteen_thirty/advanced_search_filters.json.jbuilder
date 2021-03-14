json.filters do
  AttributeBuilder.collection json, Census1900Record,:locality_id, Locality.select_options

  json.census_scope do
    json.label 'Census Schedule'
    json.sortable 'census_scope'
  end

  AttributeBuilder.text(json, :name)
  AttributeBuilder.text(json, :pob)
  AttributeBuilder.text(json, :profession)
  AttributeBuilder.text(json, :industry)

  AttributeBuilder.collection json, Census1930Record,:occupation1930_code_id, Occupation1930Code.select_options
  AttributeBuilder.collection json, Census1930Record, :industry1930_code_id, Industry1930Code.select_options

  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  AttributeBuilder.number   json, :page_number
  AttributeBuilder.enumeration json, Census1930Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1930Record, :owned_or_rented
  AttributeBuilder.number json, :home_value
  AttributeBuilder.boolean json, :has_radio
  AttributeBuilder.boolean json, :lives_on_farm
  AttributeBuilder.enumeration json, Census1930Record, :sex
  AttributeBuilder.enumeration json, Census1930Record, :race
  AttributeBuilder.age json, :age
  AttributeBuilder.enumeration json, Census1930Record, :marital_status
  AttributeBuilder.age json, :age_married
  AttributeBuilder.boolean json, :attended_school
  AttributeBuilder.boolean json, :can_read_write
  AttributeBuilder.text json, :pob
  # AttributeBuilder.text json, :pob_code
  AttributeBuilder.text json, :pob_father
  # AttributeBuilder.text json, :pob_father_code
  AttributeBuilder.text json, :pob_mother
  # AttributeBuilder.text json, :pob_mother_code
  AttributeBuilder.text json, :mother_tongue
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.enumeration json, Census1930Record, :naturalized_alien
  AttributeBuilder.boolean json, :can_speak_english
  AttributeBuilder.text json, :occupation_code
  AttributeBuilder.enumeration json, Census1930Record, :worker_class
  AttributeBuilder.boolean json, :worked_yesterday
  # AttributeBuilder.text json, :unemployment_line
  AttributeBuilder.boolean json, :veteran
  AttributeBuilder.enumeration json, Census1930Record, :war_fought
  AttributeBuilder.text json, :farm_schedule

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end


end
