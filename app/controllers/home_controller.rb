class HomeController < ApplicationController

  layout 'application'

  def index
    @html_title =  "Home - History Forge"

    @tags = Map.where(:public => true).tag_counts(:limit => 100)
    @maps = Map.where(:public => true, :status => [2,3,4]).order(:updated_at =>  :desc).limit(3).includes(:gcps)

    @layers = Layer.all.order(:updated_at => :desc).limit(3).includes(:maps)

    load_census_summaries
    load_heroes

    if user_signed_in?
      @my_maps = current_user.maps.order(:updated_at => :desc).limit(3)
    else
      @maps = @maps.published
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @maps }
    end
  end

  private

  def load_census_summaries
    @census_summaries = [
        { year: 1900, total: Census1900Record.count, reviewed: Census1900Record.reviewed.count },
        { year: 1910, total: Census1910Record.count, reviewed: Census1910Record.reviewed.count },
        { year: 1920, total: Census1920Record.count, reviewed: Census1920Record.reviewed.count },
        { year: 1930, total: Census1930Record.count, reviewed: Census1930Record.reviewed.count }
    ]
    @recent_census_summaries = [
        { year: 1900, total: Census1900Record.recently_added.count, reviewed: Census1900Record.recently_reviewed.count },
        { year: 1910, total: Census1910Record.recently_added.count, reviewed: Census1910Record.recently_reviewed.count },
        { year: 1920, total: Census1920Record.recently_added.count, reviewed: Census1920Record.recently_reviewed.count },
        { year: 1930, total: Census1930Record.recently_added.count, reviewed: Census1930Record.recently_reviewed.count }
    ]
  end

  def load_heroes
    @overall_heroes = Census1900Record.find_by_sql("SELECT users.login, COUNT(census_records.id) AS total FROM (
      SELECT id, created_by_id FROM census_1900_records
      UNION SELECT id, created_by_id FROM census_1910_records
      UNION SELECT id, created_by_id FROM census_1920_records
      UNION SELECT id, created_by_id FROM census_1930_records
    ) census_records INNER JOIN users ON census_records.created_by_id=users.id
    GROUP BY users.login ORDER BY total DESC LIMIT 10")

    @recent_heroes = Census1900Record.find_by_sql(["SELECT users.login, COUNT(census_records.id) AS total FROM (
      SELECT id, created_by_id FROM census_1900_records WHERE created_at>=:date
      UNION SELECT id, created_by_id FROM census_1910_records WHERE created_at>=:date
      UNION SELECT id, created_by_id FROM census_1920_records WHERE created_at>=:date
      UNION SELECT id, created_by_id FROM census_1930_records WHERE created_at>=:date
    ) census_records INNER JOIN users ON census_records.created_by_id=users.id
    GROUP BY users.login ORDER BY total DESC LIMIT 10", { date: 3.months.ago }])
  end

end
