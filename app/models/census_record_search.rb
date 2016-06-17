class CensusRecordSearch

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :page, :s, :f, :fs, :g, :user, :c, :d, :paged, :per, :entity_class
  attr_writer :scoped
  delegate :any?, :present?, :each, :first, :last,
           :current_page, :total_pages, :limit_value,
           to: :scoped

  validates :t, presence: true

  def to_a
    @results ||= scoped.to_a
  end

  def ransack_params
    params = @s.inject({}) { |hash, value| hash[value[0].to_sym] = value[1]; hash }
    params
  end

  def sorts
    {c: c, d: d}
  end

  def scoped
    @scoped || begin
      rp = ransack_params
      rp[:reviewed_at_not_null] = 1 unless user
      @scoped = entity_class.ransack(rp).result
      @scoped = @scoped.page(page).per(per) if paged?
      @d = 'asc' unless %w{asc desc}.include?(@d)
      if @c
        if entity_class.columns.map(&:name).include?(@c)
          add_regular_order_clause
        elsif @c == 'name'
          @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{entity_class.table_name}.data->>'last_name' #{@d}, #{entity_class.table_name}.data->>'first_name' #{@d}, #{entity_class.table_name}.data->>'middle_name' #{@d}")
        else
          @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{entity_class.table_name}.data->>'#{@c}' #{@d}")
        end
      end
    end

  end

  def add_regular_order_clause
    @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{@c} #{@d}")
  end

  def self.generate(params:{}, user:nil, entity_class:nil, paged:true, per: 5)
    new user, entity_class, params[:s], params[:page], params[:f], params[:fs], params[:g], params[:c], params[:d], true, per
  end

  def initialize(user, entity_class, scopes, page, fields, fieldsets, groupings, sort_col, sort_dir, paged, per)
    @user = user
    @entity_class = entity_class
    @page = page || 1
    @s = scopes || {}
    @f = fields || default_fields
    @fs = fieldsets || []
    @g = groupings || {}
    @c = sort_col || 'name'
    @d = sort_dir || 'asc'
    @paged = paged
    @per = per
  end

  def to_csv
    @paged = false
    require 'csv'
    CSV.generate do |csv|

      headers = []

      columns.each do |field|
        headers << I18n.t("simple_form.labels.census_record.#{field}", default: field.humanize)
      end

      csv << headers

      self.to_a.each do |row|
        row_results = []
        columns.each do |field|
          row_results << row.public_send(field)
        end
        csv << row_results
      end
    end

  end

  def paged?
    !defined?(@paged) || paged
  end

  def columns
    @columns ||= ([Set.new(f)] + fieldsets.map {|fs| Set.new public_send("#{fs}_fields") }).reduce(&:union)
  end

  def fieldsets
    @fs.present? ? @fs : %w{case_manager}
  end

  def default_fields
    %w{name sex race age marital_status relation_to_head profession industry pob street_address}
  end

  def all_fields
    %w{page_number line_number county city ward enum_dist street_address dwelling_number family_id
      name relation_to_head sex race age marital_status years_married
      num_children_born num_children_alive pob pob_father pob_mother year_immigrated
      naturalized_alien language_spoken profession industry employment
      unemployed unemployed_weeks_1909 can_read can_write attended_school
      owned_or_rented mortgage farm_or_house civil_war_vet blind deaf_dumb
    }
  end

  def all_fieldsets
    %w{census_scope location}
  end

  def census_scope_fields
    %w{page_number line_number county city ward enum_dist dwelling_number family_id}
  end

  def location_fields
    %w{street_house_number street_prefix street_name street_suffix}
  end

end