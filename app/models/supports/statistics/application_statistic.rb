class Supports::Statistics::ApplicationStatistic
  def initialize args = {}
    @check = args[:check]
    @location_ids = args[:location_ids] || load_locations.map(&:id)
    @check_params_location = args[:location_ids]
    @trainee_type_ids = args[:trainee_type_ids] || load_trainee_types.map(&:id)
    @stage_ids = args[:stage_ids] || load_stages.map(&:id)
    @start_date = args[:start_date] || Date.today - 6.month
    @end_date = args[:end_date] || Date.today
  end

  def load_locations
    @locations ||= Location.all
  end

  def load_all_trainee
    @trainee_ids ||= Trainee.all.pluck :id
  end

  def load_trainee_types
    @load_trainee_types ||= TraineeType.all
  end

  def load_stages
    @stages ||= Stage.all
  end

  def month_ranges
    months
  end

  private
  def convert_to_hash statistic
    Hash[:trainee_type, statistic.trainee_type_name, :language,
      statistic.language_name]
  end

  def months
    date_range = @start_date.to_date..@end_date.to_date
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
    date_months.map {|d| d.strftime I18n.t('datetime.formats.year_month')}
  end

  def load_languages
    @languages ||= Language.all
  end

  def trainee_by_statistic load_trainee_by_location_and_type, type_statistic
    @load_trainee_by_location_and_type = load_trainee_by_location_and_type
    unless @load_all_trainee
      none_statistic = Hash[:name, I18n.t("statistics.none"), :y, 0]
      all_statistics = Object.const_get("#{type_statistic.classify}")
        .all.map do |u|
        Hash[:name, u[:name], :y, 0]
      end
      @load_trainee_by_location_and_type.each do |trainee|
        if trainee.language && trainee.send(type_statistic)
          found_language = all_statistics.find do |u|
            u[:name] == trainee.send(type_statistic).name
          end
          found_language[:y] += 1
        else
          none_statistic[:y] += 1
        end
      end
      all_statistics << none_statistic
      @load_all_trainee = all_statistics.sort_by {|u| u[:y]}
        .reverse
    end
    @load_all_trainee
  end

end
