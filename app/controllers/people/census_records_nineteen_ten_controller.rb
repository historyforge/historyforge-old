class People::CensusRecordsNineteenTenController < People::CensusRecordsController

  def resource_path(*args)
    census1910_record_path(*args)
  end

  def edit_resource_path(*args)
    edit_census1910_record_path(*args)
  end

  def new_resource_path(*args)
    new_census1910_record_path(*args)
  end

  def save_as_resource_path(*args)
    save_as_census1910_record_path(*args)
  end

  def review_resource_path(*args)
    review_census1910_record_path(*args)
  end

  def collection_path(*args)
    census1910_records_path(*args)
  end

  helper_method :resource_path,
                :edit_resource_path,
                :new_resource_path,
                :save_as_resource_path,
                :review_resource_path,
                :collection_path

  private

  def resource_class
    Census1910Record
  end

  def page_title
    '1910 Census Records'
  end



end
