class Census1920FormFields < CensusFormFields
  input :last_name,
               input_html: { autocomplete: 'new-password' },
               hint: -> { last_name_hint }

  input :first_name,
               input_html: { autocomplete: 'new-password' },
               hint: -> { first_name_hint }

  input :middle_name,
               input_html: { autocomplete: 'new-password' },
               hint: -> { middle_name_hint }

  input :name_prefix,
               input_html: { autocomplete: 'new-password' },
               hint: -> { title_hint }

  input :name_suffix,
               input_html: { autocomplete: 'new-password' },
               hint: -> { suffix_hint }

  input :relation_to_head,
               input_html: { autocomplete: 'new-password' },
               hint: -> { relation_to_head_hint }

  input :owned_or_rented,
               as: :radio_buttons,
               collection: Census1920Record.owned_or_rented_choices,
               coded: true,
               hint: -> { owned_or_rented_hint }

  input :mortgage,
               as: :radio_buttons,
               collection: Census1920Record.mortgage_choices,
               coded: true,
               hint: -> { mortgage_hint }

  input :sex,
               as: :radio_buttons,
               collection: Census1920Record.sex_choices,
               coded: true,
               hint: -> { sex_hint }

  input :race,
               as: :radio_buttons,
               collection: Census1920Record.race_choices,
               coded: true,
               hint: -> { race_hint }

  input :age,
               hint: -> { age_hint }

  input :age_months,
               hint: 'Only for children less than 5 years old'

  input :marital_status,
               as: :radio_buttons,
               collection: Census1920Record.marital_status_choices,
               coded: true,
               hint: -> { column_hint(12) }

  input :foreign_born,
               as: :boolean,
               label: 'This person is foreign born',
               inline_label: 'Yes',
               hint: -> { foreign_born_hint }

  input :year_immigrated,
               as: :integer,
               hint: -> { unknown_year_hint(13) }

  input :naturalized_alien,
               as: :radio_buttons,
               collection: Census1920Record.naturalized_alien_choices,
               coded: true,
               hint: -> { unknown_hint(14) }

  input :year_naturalized,
               as: :integer,
               hint: -> { unknown_year_hint(15) }

  input :attended_school,
               as: :boolean,
               inline_label: 'Attended School?',
               hint: -> { attended_school_hint }

  input :can_read,
               as: :boolean,
               inline_label: 'Yes',
               label: 'Can Read?',
               hint: -> { boolean_hint(17) }

  input :can_write,
               as: :boolean,
               inline_label: 'Yes',
               label: 'Can Write?',
               hint: -> { boolean_hint(18) }

  input :pob,
               input_html: { autocomplete: 'new-password' },
               hint: -> { pob_hint(19) }

  input :mother_tongue,
               input_html: { autocomplete: 'new-password' },
               hint: -> { mother_tongue_hint(20) }

  input :pob_father,
               input_html: { autocomplete: 'new-password' },
               hint: -> { pob_hint(21) }

  input :mother_tongue_father,
               input_html: { autocomplete: 'new-password' },
               hint: -> { mother_tongue_hint(22) }

  input :pob_mother,
               input_html: { autocomplete: 'new-password' },
               hint: -> { pob_hint(23) }

  input :mother_tongue_mother,
               input_html: { autocomplete: 'new-password' },
               hint: -> { mother_tongue_hint(23) }

  input :can_speak_english,
               as: :boolean, inline_label: 'Yes',
               label: 'Speaks English?',
               hint: -> { boolean_hint(25) }

  input :profession,
               input_html: { autocomplete: 'new-password' },
               hint: -> { column_hint(26) }

  input :industry,
               input_html: { autocomplete: 'new-password' },
               hint: -> { column_hint(27) }

  input :employment,
               as: :radio_buttons,
               collection: Census1920Record.employment_choices,
               coded: true,
               hint: -> { column_hint(28) }

  input :farm_schedule,
               hint: -> { farm_schedule_hint(29) }

  input :employment_code,
               hint: -> { employment_code_hint }

end