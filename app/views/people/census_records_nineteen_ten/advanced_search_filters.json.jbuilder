json.filters do
  AttributeBuilder.collection json, Census1910Record,:locality_id, Locality.select_options

  json.census_scope do
    json.label 'Census Schedule'
    json.sortable 'census_scope'
  end

  AttributeBuilder.text(json, :name)
  AttributeBuilder.text(json, :pob)
  AttributeBuilder.text(json, :profession)
  AttributeBuilder.text(json, :industry)

  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  AttributeBuilder.number   json, :page_number
  AttributeBuilder.enumeration json, Census1910Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1910Record, :sex
  AttributeBuilder.enumeration json, Census1910Record, :race
  AttributeBuilder.age    json, :age
  AttributeBuilder.enumeration json, Census1910Record, :marital_status
  AttributeBuilder.number json, :years_married
  AttributeBuilder.number json, :num_children_born
  AttributeBuilder.number json, :num_children_alive
  AttributeBuilder.text json, :pob
  AttributeBuilder.text json, :pob_father
  AttributeBuilder.text json, :pob_mother
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.enumeration json, Census1910Record, :naturalized_alien
  AttributeBuilder.text json, :language_spoken
  AttributeBuilder.text json, :mother_tongue
  AttributeBuilder.text json, :mother_tongue_father
  AttributeBuilder.text json, :mother_tongue_mother
  AttributeBuilder.enumeration json, Census1910Record, :employment
  AttributeBuilder.boolean json, :unemployed
  AttributeBuilder.number json, :unemployed_weeks_1909
  AttributeBuilder.boolean json, :can_read
  AttributeBuilder.boolean json, :can_write
  AttributeBuilder.boolean json, :attended_school
  AttributeBuilder.enumeration json, Census1910Record, :owned_or_rented
  AttributeBuilder.enumeration json, Census1910Record, :mortgage
  AttributeBuilder.enumeration json, Census1910Record, :farm_or_house
  AttributeBuilder.number json, :num_farm_sched
  AttributeBuilder.boolean json, :blind
  AttributeBuilder.enumeration json, Census1910Record, :civil_war_vet
  AttributeBuilder.boolean json, :deaf_dumb

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end
end
