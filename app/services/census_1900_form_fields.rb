class Census1900FormFields < CensusFormFields
  input :last_name, input_html: { autocomplete: 'new-password' }
  input :first_name, input_html: { autocomplete: 'new-password' }
  input :middle_name, input_html: { autocomplete: 'new-password' }
  input :name_prefix, input_html: { autocomplete: 'new-password' }
  input :name_suffix, input_html: { autocomplete: 'new-password' }
  input :relation_to_head, input_html: { autocomplete: 'new-password' }
  input :race, as: :radio_buttons, collection: Census1900Record.race_choices, coded: true
  input :sex, as: :radio_buttons, collection: Census1900Record.sex_choices, coded: true
  input :birth_month, as: :radio_buttons, collection: (1..12).map { |m| ["#{m} - #{Date::MONTHNAMES[m]}", m] }, include_blank: true
  input :birth_year
  input :age, hint: 'Enter 999 for unknown or leave blank if taker left empty'
  input :age_months, hint: 'Only for children less than 5 years old'
  input :marital_status, as: :radio_buttons, collection: Census1900Record.marital_status_choices, coded: true
  input :years_married, as: :integer, input_html: { min: 0 }
  input :num_children_born, as: :integer, input_html: { min: 0 }
  input :num_children_alive, as: :integer, input_html: { min: 0 }
  input :pob, input_html: { autocomplete: 'new-password' }
  input :pob_father, input_html: { autocomplete: 'new-password' }
  input :pob_mother, input_html: { autocomplete: 'new-password' }
  input :foreign_born,
               as: :boolean,
               label: 'This person is foreign born',
               inline_label: 'Yes',
               wrapper_html: {data: {dependents: 'true'}}

  input :year_immigrated,
               as: :integer,
               hint: 'Enter 999 for unknown or leave blank if taker left empty',
               wrapper_html: {data: {depends_on: :foreign_born}}

  input :years_in_us,
               as: :integer,
               wrapper_html: {data: {depends_on: :foreign_born}}

  input :naturalized_alien,
               as: :radio_buttons,
               collection: Census1900Record.naturalized_alien_choices,
               coded: true,
               wrapper_html: { data: { depends_on: :foreign_born } },
               hint: -> { citizenship_hint }

  input :profession, hint: 'Enter "None" if empty', input_html: { autocomplete: 'new-password' }
  input :industry, input_html: { autocomplete: 'new-password' }
  input :unemployed_months, as: :integer
  input :attended_school, as: :integer, inline_label: 'Attended School?', hint: 'No. of months'
  input :can_read, as: :boolean, label: 'Can Read?', inline_label: 'Yes'
  input :can_write, as: :boolean, label: 'Can Write?', inline_label: 'Yes'
  input :can_speak_english, as: :boolean, label: 'Can speak English?', inline_label: 'Yes'
  input :owned_or_rented, as: :radio_buttons, collection: Census1910Record.owned_or_rented_choices, coded: true
  input :mortgage, as: :radio_buttons, collection: Census1910Record.mortgage_choices, coded: true
  input :farm_or_house, as: :radio_buttons, collection: Census1910Record.farm_or_house_choices, coded: true
  input :farm_schedule, as: :integer

end