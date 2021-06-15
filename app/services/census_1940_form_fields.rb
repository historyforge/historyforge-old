class Census1940FormFields < CensusFormFields
  input :owned_or_rented,
               as: :radio_buttons,
               collection: Census1940Record.owned_or_rented_choices,
               label: 'Home owned or rented',
               coded: true,
               hint: -> {owned_or_rented_hint}

  input :home_value,
               label: 'Value of home or monthly payment',
               hint: -> {home_value_hint}

  input :lives_on_farm,
               as: :boolean,
               label: 'Live on Farm?',
               inline_label: 'Yes',
               hint: -> {lives_on_farm_hint}

  input :last_name,
               input_html: {autocomplete: 'new-password'},
               hint: -> {name_hint}

  input :first_name,
               input_html: {autocomplete: 'new-password'},
               hint: -> {name_hint}

  input :middle_name,
               input_html: {autocomplete: 'new-password'},
               hint: -> {name_hint}

  input :name_prefix,
               input_html: {autocomplete: 'new-password'}

  input :name_suffix,
               input_html: {autocomplete: 'new-password'}

  input :relation_to_head,
               input_html: { autocomplete: 'new-password' },
               hint: -> {relation_to_head_hint}

  input :sex,
               as: :radio_buttons,
               collection: Census1940Record.sex_choices,
               coded: true,
               hint: -> {sex_hint}

  input :race,
               as: :radio_buttons_other,
               collection: Census1940Record.race_choices,
               coded: true,
               hint: -> {race_hint}

  input :age,
               hint: -> {age_hint}

  input :age_months,
               hint: -> {age_hint}

  input :marital_status,
               as: :radio_buttons,
               collection: Census1940Record.marital_status_choices,
               coded: true,
               hint: -> {marital_status_hint}

  input :attended_school,
               as: :boolean,
               label: 'Attended school or college?',
               inline_label: 'Yes',
               hint: -> {attended_school_hint}

  input :grade_completed,
               collection: Census1940Record.grade_completed_choices,
               as: :radio_buttons,
               hint: -> { grade_completed_hint }

  input :pob,
               input_html: { autocomplete: 'new-password' },
               hint: -> { pob_1940_hint(15) }

  input :foreign_born,
               as: :boolean,
               label: 'This person is foreign born',
               inline_label: 'Yes',
               wrapper_html: { data: { dependents: 'true' } }

  input :naturalized_alien,
               as: :radio_buttons,
               collection: Census1940Record.naturalized_alien_choices,
               coded: true,
               wrapper_html: { data: { depends_on: :foreign_born } },
               hint: -> { citizenship_hint }

  divider "Status in 1935"

  input :residence_1935_town,
               input_html: { autocomplete: 'new-password' },
               hint: -> { residence_1935_town_hint }

  input :residence_1935_county,
               input_html: { autocomplete: 'new-password' },
               hint: "Column 18. Enter as written."

  input :residence_1935_state,
               input_html: { autocomplete: 'new-password' },
               hint: "Column 19. Enter as written."

  input :residence_1935_farm,
               as: :boolean,
               inline_label: 'Yes',
               hint: "Column 20. Check if the response is yes."

  divider "Employment & Income"

  input :private_work,
               as: :boolean,
               inline_label: 'Yes',
               hint: "Column 21. Check if the response is yes."

  input :public_work,
               as: :boolean,
               inline_label: 'Yes',
               hint: "Column 22. Check if the response is yes."

  input :seeking_work,
               as: :boolean,
               inline_label: 'Yes',
               hint: "Column 23. Check if the response is yes."

  input :had_job,
               as: :boolean,
               inline_label: 'Yes',
               hint: "Column 24. Check if the response is yes."

  input :no_work_reason,
               collection: Census1940Record.no_work_reason_choices,
               coded: true,
               as: :radio_buttons,
               hint: "Column 25. Check box that corresponds to the answer indicated."

  input :private_hours_worked,
               as: :integer,
               hint: "Column 26. Enter as written."

  input :unemployed_weeks,
               as: :integer,
               hint: "Column 27. Enter as written."

  input :occupation,
               hint: 'Column 28. Enter as written. Enter "None" if empty',
               input_html: { autocomplete: 'new-password' }

  input :industry,
               input_html: { autocomplete: 'new-password' },
               hint: 'Column 29. Enter as written.'

  input :worker_class,
               collection: Census1940Record.worker_class_choices,
               coded: true,
               as: :radio_buttons,
               hint: 'Column 30. Check the box that corresponds to the answer indicated.'

  input :occupation_code,
               input_html: {autocomplete: 'new-password'},
               hint: -> {occupation_code_hint('F') }

  input :industry_code,
               input_html: {autocomplete: 'new-password'},
               hint: -> {occupation_code_hint('F') }

  input :worker_class_code,
               input_html: {autocomplete: 'new-password'},
               hint: -> {occupation_code_hint('F') }

  input :full_time_weeks,
               as: :integer,
               hint: 'Column 31. Enter as written.'

  input :income,
               as: :integer,
               hint: 'Column 32. Enter as written.'

  input :had_unearned_income,
               as: :boolean,
               inline_label: 'Yes',
               hint: 'Column 33. Check box if the response is yes.'

  input :farm_schedule,
               label: 'Farm Number',
               hint: 'Column 34. Enter as written.'
end
