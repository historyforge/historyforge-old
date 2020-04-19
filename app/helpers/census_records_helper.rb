module CensusRecordsHelper

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
    raw html
  end

  def side_hint
    html = content_tag(:p, "Each census sheet has side <u>A</u> and <u>B</u>.".html_safe)
    html << image_tag('1920/sheet-side.png') if controller.year == 1920
    raw html
  end

  def line_number_hint
    html = content_tag(:p, "Each sheet has 50 lines, they are located in the margin on the left and right side of the sheet.")
    html << content_tag(:p, "Side A usually contains lines 1-50 and Side B lines 51-100.")
    raw html
  end

  def ward_hint
    return unless controller.year == 1920
    html = content_tag :p, "The ward is in the upper right corner in the header underneath the Enumeration District. Enter ward as a number (2)."
    html << image_tag('1920/sheet-side.png')
    raw html
  end

  def enumeration_district_hint
    return unless controller.year == 1920
    html = content_tag :p, "The Enumeration District is in the upper right corner in the header underneath the Supervisor's District. Enter as a number (185)."
    html << image_tag('1920/sheet-side.png')
    raw html
  end

  def house_number_hint
    html = ''
    html << content_tag(:p, "Column 2.") if controller.year == 1920
    html << content_tag(:p, "If the number includes a fraction leave a space between the number and the fraction. i.e. 102 ½.")
    html << content_tag(:p, "If the number indicates rear (as in rear apartment) enter the street number followed by a space and the word Rear, i.e. 313 Rear.")
    html << content_tag(:p, "If the number includes a range enter as written, i.e. 102-104.")
    raw html
  end

  def street_prefix_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920

    html << content_tag(:p, "North, South, East, West preceding the street name.")
    html << content_tag(:p, "<b>Exception:</b> on occasion the street name will include North, South, East or West, as in South Hill Terrace.  In this case you would include South in the street address, not the prefix.".html_safe)
    raw html
  end

  def street_name_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920
    html << content_tag(:p, "The name of the street itself, i.e. Aurora. If you enter a space followed by the suffix into this column by mistake, make sure to delete both the suffix and the extra space.")
    html << content_tag(:p, "<b>Note:</b> Street names can change at least once on the sheet.  These changes are often indicated by a hand-drawn line across the column separating the buildings on one street from the next.".html_safe)
    raw html
  end

  def street_suffix_hint
    html = ''
    html << content_tag(:p, "Column 1.") if controller.year == 1920
    html << content_tag(:p, "Avenue, Road, Street, etc.")
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
    html << content_tag(:p, "Enter as written. In some cases, if the first person on the sheet is not the head of household the dwelling and family numbers will not be listed but instead can be found on the previous census sheet.")
    html << content_tag(:p, "<b>Note:</b> Dwelling and Family numbers are generally sequential.  If it is hard to read either number check the numbers above and below for a pattern.".html_safe)
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
    html << content_tag(:p, "This field indicates the relationship of each person to the Head of the family (i.e. Head, Wife, Mother, Father, Son, Daughter, Grandson, Daughter-in-Law, Aunt, Uncle, Nephew, Niece, Boarder, Lodger, Servant, etc.). For the Head of household enter Head, do not the number to the right of Head.")
    html << content_tag(:p, "For the census “family” is defined as “a group of persons living together in the same dwelling place.”")
    raw html
  end

  def owned_or_rented_hint
    html = ''
    html << content_tag(:p, 'Column 7.') if controller.year == 1920
    html << content_tag(:p, "For head of household only.  Enter as written, generally O-Owned, R-Rented.  If the response is Un (see image below), enter as Unknown.")
    html << image_tag('1920/unknown-scribble.png')
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
    return unless controller.year == 1920
    html = ''
    html << content_tag(:p, 'Column 9.') if controller.year == 1920
    raw html
  end

  def race_hint
    return unless controller.year == 1920
    html = ''
    html << content_tag(:p, 'Column 10.') if controller.year == 1920
    raw html
  end

  def age_hint
    html = ''
    html << content_tag(:p, 'Column 11.') if controller.year == 1920
    html << content_tag(:p, "Enter 999 for unknown or leave blank if taker left empty")
    html << content_tag(:p, "A child 5 years of age or under will likely be listed by their age in years and months i.e. 4 and 3/12 or 11/12. If the child is 5 or under enter the age in years in the Age field and the age in months in Age (months).")
    html << content_tag(:p, "If they are less than 1 enter O in the Age field, then enter the months in Age (months)")
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

  def attended_school_hint
    html = ''
    html << content_tag(:p, 'Column 16.') if controller.year == 1920
    html << content_tag(:p, "Whether this person attended school anytime since September 1, 1919.  Only check if the response is yes.")
    raw html
  end

  def employment_code_hint
    html = content_tag :p, "There is no official column for this on the census, these 3-digit numbers which range from 000-999 were added in the right margin or sometimes under farm number. Please enter the numbers here."
    raw html
  end

  def notes_hint
    html = content_tag :p, "If you find additional or conflicting information about the person from a different source such as a different name spelling or address, include the information as written by the enumerator in the relevant field and enter the alternative information here and its source. If you checked the city directory, include the year. i.e. The address in the 1919 City Directory is _________________. "
    html << content_tag(:p, "<b>* Important</b> - the information in the notes field will become public.".html_safe)
    raw html
  end
end
