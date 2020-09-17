module CensusRecordsHelper

  def translated_label(klass, key)
    I18n.t("simple_form.labels.#{klass ? klass.name.underscore : nil}.#{key}", default:
      I18n.t("simple_form.labels.census_record.#{key}", default:
        I18n.t("simple_form.labels.defaults.#{key}", default: (klass ? klass : CensusRecord).human_attribute_name(key))))
  end

  def select_options_for(collection)
    [["blank", 'nil']] + collection.zip(collection)
  end

  def yes_no_choices
    [["Left blank", nil], ["Yes", true], ["No", false]]
  end

  def prepare_blanks_for_1910_census(record)
    record.civil_war_vet     ||= 'nil' #if record.civil_war_vet.nil?
    # record.unemployed        = 'nil' if record.unemployed.nil?
    record.naturalized_alien ||= 'nil' #if record.naturalized_alien.nil?
    record.owned_or_rented   ||= 'nil' #if record.owned_or_rented.nil?
    record.mortgage          ||= 'nil' #if record.mortgage.nil?
    record.farm_or_house     ||= 'nil' #if record.farm_or_house.nil?
    record.civil_war_vet     ||= 'nil' #if record.civil_war_vet.nil?
    # record.can_read          = 'nil' if record.can_read.nil?
    # record.can_write         = 'nil' if record.can_write.nil?
    # record.attended_school   = 'nil' if record.attended_school.nil?
    # raise record.inspect
  end

  def yes_no_na(value)
    if value.nil?
      'blank'
    else
      value ? 'yes' : 'no'
    end
  end

  def sheet_hint
    html = content_tag(:p, "The <u>Sheet</u> or page number is in the upper right corner in the header.".html_safe)
    html << image_tag('1920/sheet-side.png') if controller.year == 1920
    html << image_tag('1940/sheet-side.png') if controller.year == 1940
    raw html
  end

  def side_hint
    html = content_tag(:p, "Each census sheet has side <u>A</u> and <u>B</u>.".html_safe)
    html << image_tag('1920/sheet-side.png') if controller.year == 1920
    html << image_tag('1940/sheet-side.png') if controller.year == 1940
    raw html
  end

  def line_number_hint
    if controller.year == 1940
      html = content_tag(:p, 'Each sheet has 40 lines. The line numbers are located on the left and right side of the sheet.')
      html << content_tag(:p, 'Side A usually contains lines 1-40 and Side B lines 41-80.')
    else
      html = content_tag(:p, "Each sheet has 50 lines, they are located in the margin on the left and right side of the sheet.")
      html << content_tag(:p, "Side A usually contains lines 1-50 and Side B lines 51-100.")
    end
    raw html
  end

  def ward_hint
    if controller.year == 1920
      html = content_tag :p, "The ward is in the upper right corner in the header underneath the Enumeration District. Enter ward as a number (2)."
      html << image_tag('1920/sheet-side.png')
      raw html
    elsif controller.year == 1940
      html = content_tag :p, "The ward is to the left of the center title \"Sixteenth Census of the United States: 1940\". Enter ward as a number (2)."
      html << image_tag('1940/ward.png')
      raw html
    end
  end

  def enumeration_district_hint
    if controller.year == 1920
      html = content_tag :p, "The Enumeration District is in the upper right corner in the header underneath the Supervisor's District. Enter as a number (185)."
      html << image_tag('1920/sheet-side.png')
      raw html
    elsif controller.year == 1940
      html = content_tag :p, "The Enumeration District (ED) is in the upper right corner in the header next to the sheet number. Enter the last 2 digits only."
      html << image_tag('1940/sheet-side.png')
      raw html
    end
  end

  def house_number_hint
    html = ''
    html << content_tag(:p, "Column 2.") if controller.year == 1920 || controller.year == 1940
    html << content_tag(:p, "If the number includes a fraction leave a space between the number and the fraction. i.e. 102 ½.")
    html << content_tag(:p, "If the number indicates rear (as in rear apartment) enter the street number followed by a space and the word Rear, i.e. 313 Rear.")
    html << content_tag(:p, "If the number includes a range enter as written, i.e. 102-104.")
    raw html
  end

  def street_prefix_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920 || controller.year == 1940

    html << content_tag(:p, "North, South, East, West preceding the street name.")
    html << content_tag(:p, "<b>Exception:</b> on occasion the street name will include North, South, East or West, as in South Hill Terrace.  In this case you would include South in the street address, not the prefix.".html_safe)
    raw html
  end

  def street_name_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920 || controller.year == 1940
    html << content_tag(:p, "The name of the street itself, i.e. Aurora. If you enter a space followed by the suffix into this column by mistake, make sure to delete both the suffix and the extra space.")
    html << content_tag(:p, "<b>Note:</b> Street names can change at least once on the sheet.  These changes are often indicated by a hand-drawn line across the column separating the buildings on one street from the next.".html_safe)
    raw html
  end

  def street_suffix_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920 || controller.year == 1940
    html << content_tag(:p, "Avenue, Road, Street, etc. If you are unsure, check the city directory or search the HF building database for the street name to see how it has been entered before.")
    raw html
  end

  def building_hint
    html = content_tag :p, "There is no corresponding field on the census, however, this field allows us to link the people in the census to a mapped building."
    html << content_tag(:p, "From the drop down menu select the building with the same address. If the building number is not listed, click Add building with address.")
    raw html
  end

  def dwelling_number_hint
    html = ''
    html << content_tag(:p, "Column 3.") if controller.year == 1920
    html << content_tag(:p, "A building with multiple families but one entrance usually has a single dwelling number. Enter as written.  *In some cases, if the first person on the sheet is not the head of household the dwelling and family numbers will not be listed but instead can be found on the previous census sheet.")
    html << content_tag(:p, "<b>Note:</b> Dwelling and Family numbers are generally sequential.  If it is hard to read either number check the numbers above and below for a pattern.".html_safe)
    raw html
  end

  def family_id_hint
    html = ''
    html << content_tag(:p, "Column 4.") if controller.year == 1920
    html << content_tag(:p, "Column 3.") if controller.year == 1940
    html << content_tag(:p, "Enter as written. In some cases, if the first person on the sheet is not the head of household the dwelling and family numbers will not be listed but instead can be found on the previous census sheet.")
    html << content_tag(:p, "<b>Note:</b> Dwelling and Family numbers are generally sequential.  If it is hard to read either number check the numbers above and below for a pattern.".html_safe)
    raw html
  end

  def name_hint
    html = content_tag(:p, 'Column 7.')
    html << content_tag(:p, "Names are listed Last, First, Middle. If several members of a family have the same last name, the last name will be listed in the first record and in following records it usually will be replaced by a line. Enter the last name for each individual. If there is no middle name or initial, leave the field blank.")
    html << image_tag('1940/names.png')
    raw html
  end

  def last_name_hint
    html = ''
    html << content_tag(:p, 'Column 5.') if controller.year == 1920
    html << content_tag(:p, "Names are listed Last, First, Middle.")
    html << content_tag(:p, "If several members of a family have the same last name, the last name will be listed in the first record and in following records it will be replaced by a line.")
    html << content_tag(:p, "Enter the last name for each individual.")
    html << image_tag('1920/names.png')
    raw html
  end

  def middle_name_hint
    html = ''
    html << content_tag(:p, 'Column 5.') if controller.year == 1920
    html << content_tag(:p, "Names are listed Last, First, Middle.")
    html << content_tag(:p, "If there is no middle name or initial leave the field blank.")
    html << image_tag('1920/names.png')
    raw html
  end

  def first_name_hint
    html = ''
    html << content_tag(:p, 'Column 5.') if controller.year == 1920
    html << content_tag(:p, "Names are listed Last, First, Middle.")
    html << image_tag('1920/names.png')
    raw html
  end

  def title_hint
    html = ''
    html << content_tag(:p, 'Column 5.') if controller.year == 1920
    html << content_tag(:p, "Enter as written, if no title leave the field(s) blank.")
    raw html
  end

  def suffix_hint
    html = ''
    html << content_tag(:p, 'Column 5.') if controller.year == 1920
    html << content_tag(:p, "Enter as written, if no suffix leave the field(s) blank.")
    raw html
  end

  def relation_to_head_hint
    html = ''
    html << content_tag(:p, 'Column 6.') if controller.year == 1920
    html << content_tag(:p, 'Column 7.') if controller.year == 1940
    html << content_tag(:p, "This field indicates the relationship of each person to the Head of the family (i.e. Head, Wife, Mother, Father, Son, Daughter, Grandson, Daughter-in-Law, Aunt, Uncle, Nephew, Niece, Boarder, Lodger, Servant, etc.). For the Head of household enter Head, do not the number to the right of Head.")
    html << content_tag(:p, "For the census “family” is defined as “a group of persons living together in the same dwelling place.”")
    raw html
  end

  def owned_or_rented_hint
    html = ''
    html << content_tag(:p, 'Column 7.') if controller.year == 1920
    html << content_tag(:p, 'Column 4.') if controller.year == 1940
    html << content_tag(:p, "For head of household only.  Enter as written, generally O-Owned, R-Rented.  If the response is Un (see image below), enter as Unknown.")
    html << image_tag('1920/unknown-scribble.png')
    raw html
  end

  def home_value_hint
    html = content_tag(:p, 'Column 5.')
    html << content_tag(:p, "For head of household only. Enter as written. If the response is Un (see image below), enter as 999.")
    html << image_tag('1920/unknown-scribble.png')
    raw html
  end

  def lives_on_farm_hint
    html = content_tag(:p, 'Column 6.')
    html << content_tag(:p, "Check the box if the response is yes.")
    raw html
  end

  def mortgage_hint
    html = ''
    html << content_tag(:p, 'Column 8.') if controller.year == 1920
    html << content_tag(:p, "For head of household only.  Enter as written, generally M-Mortgage, F-Free of Mortgage.  If the response is Un (see image below), enter as Unknown.")
    html << image_tag('1920/unknown-scribble.png')
    raw html
  end

  def sex_hint
    return unless controller.year == 1920 || controller.year == 1940
    html = ''
    html << content_tag(:p, 'Column 9.')
    html << content_tag(:p, 'Check the box that corresponds to the answer indicated.')
    raw html
  end

  def race_hint
    return unless controller.year == 1920 || controller.year == 1940
    html = ''
    html << content_tag(:p, 'Column 10.')
    html << content_tag(:p, 'Check the box that corresponds to the answer indicated.')
    raw html
  end

  def age_hint
    html = ''
    html << content_tag(:p, 'Column 11.') if controller.year == 1920 || controller.year == 1940
    html << content_tag(:p, "Enter 999 for unknown or leave blank if taker left empty")
    if controller.year == 1940
      html << content_tag(:p, "A child that is <b>less than one year of age</b> will be listed by their age in months i.e. 3/12 or 11/12.".html_safe)
    else
      html << content_tag(:p, "A child 5 years of age or under will likely be listed by their age in years and months i.e. 4 and 3/12 or 11/12. If the child is 5 or under enter the age in years in the Age field and the age in months in Age (months).")
    end
    html << content_tag(:p, "If they are less than 1 enter O in the Age field, then enter the months in Age (months)")
    raw html
  end

  def marital_status_hint
    html = content_tag(:p, 'Column 12.')
    html << content_tag(:p, 'Check the box that corresponds to the answer indicated.')
    raw html
  end

  def column_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    raw html
  end

  def foreign_born_hint
    return unless controller.year == 1920
    html = content_tag :p, 'There is no corresponding field on the census.  Check this box if the individual is not born in the United States (see column 19).'
    raw html
  end

  def boolean_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, "Only check if the response is yes.")
    raw html
  end

  def unknown_year_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, "Enter as written, leave blank if blank.  If the response is Un (see image below), enter as 999.")
    raw html
  end

  def unknown_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, "Enter as written, leave blank if blank.  If the response is Un (see image below), enter as Unknown.")
    html << image_tag('1920/unknown-scribble.png')
    raw html
  end

  def farm_schedule_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, " If a 1- or 2-digit number, enter here.  If a 3-digit number, enter under Employment code.")
    raw html
  end

  def mother_tongue_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, "Generally, for foreign born only.  Enter as written, leave blank if blank.  If the enumerator wrote un (see below) or don’t know enter Unknown.")
    html << image_tag('1920/unknown-scribble.png')
    raw html
  end

  def pob_hint(col=false)
    html = ''
    html << content_tag(:p, "Column #{col}.") if col
    html << content_tag(:p, "New York is the default which can be overwritten. Enter the State/Territory/Country name as written by the enumerator, if the enumerator abbreviated, spell out the place of birth.")
    html << content_tag(:p, "Enter US or variants as <u>United States</u>".html_safe)
    html << content_tag(:p, "Enter Washington D.C. as <u>District of Columbia</u>.".html_safe)
    html << content_tag(:p, "Those born abroad of American parents will have the designation <u>Am Cit</u> after their place of birth. Include that in the place of birth field.".html_safe)
    raw html
  end

  def pob_1940_hint(column)
    html = ''
    html << content_tag(:p, "Column #{column}.")
    html << content_tag(:p, "New York is the default which can be overwritten. Enter the State/Territory/Country name as written by the enumerator, if the enumerator abbreviated, spell out the place of birth.")
    html << content_tag(:p, "Enter US or variants as <u>United States</u>".html_safe)
    html << content_tag(:p, "Enter Washington D.C. as <u>District of Columbia</u>.".html_safe)
    html << content_tag(:p, "Make sure to capture whether <u>Canada French</u> or <u>Canada English</u>, <u>Irish Free State</u> or <u>Northern Ireland</u>.".html_safe)
    raw html
  end

  def attended_school_hint
    html = ''
    html << content_tag(:p, 'Column 16.') if controller.year == 1920
    html << content_tag(:p, 'Column 13.') if controller.year == 1940
    html << content_tag(:p, "Only check if the response is yes.")
    raw html
  end

  def grade_completed_hint
    html = content_tag(:p, 'Column 14.')
    html << image_tag('1940/grade-completed.png')
    raw html
  end

  def employment_code_hint
    html = content_tag :p, "There is no official column for this on the census, these 3-digit numbers which range from 000-999 were added in the right margin or sometimes under farm number. Please enter the numbers here."
    raw html
  end

  def citizenship_hint
    html = content_tag(:p, 'Column 16.')
    html << image_tag('1940/citizenship.png')
    raw html
  end

  def residence_1935_town_hint
    html = content_tag(:p, 'Column 17. Enter as written.')
    html << content_tag(:p, "Those who lived in the same house in 1935 will be listed as <u>Same House</u>.".html_safe)
    html << content_tag(:p, "Those who lived in a different house in the same city, town, or village will be listed as <u>Same Place</u>.".html_safe)
    html << content_tag(:p, "Those who lived in a rural area will be listed as <u>R</u>.".html_safe)
    raw html
  end

  def occupation_code_hint(column)
    html = content_tag(:p, "Column #{column}.".html_safe)
    html << content_tag(:p, 'This is a three-figure code followed by a two-figure industry code and a 1-figure worker class code.'.html_safe)
    html << content_tag(:p, 'The <b>occupation</b> code can contain a <b>"V"</b> or an <b>"X"</b> as well as numbers.'.html_safe)
    html << content_tag(:p, 'The <b>indurstry</b> code can contain a <b>"V"</b> or an <b>"X"</b> as well as numbers.'.html_safe)
    html << content_tag(:p, 'The <b>worker class</b> code is a number from 1 to 6.'.html_safe)
    html << image_tag('1940/occupation-codes.png')
    raw html
  end

  def notes_hint
    html = content_tag :p, "If you find additional or conflicting information about the person from a different source such as a different name spelling or address, include the information as written by the enumerator in the relevant field and enter the alternative information here and its source. If you checked the city directory, include the year. i.e. The address in the 1919 City Directory is _________________. "
    html << content_tag(:p, "<b>* Important</b> - the information in the notes field will become public.".html_safe)
    raw html
  end
end
