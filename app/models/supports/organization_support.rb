class Supports::OrganizationSupport
  def initialize args = {}
    @trainees ||= Trainee.traine_in_education.includes user_subjects: :subject, 
      profile: :trainee_type
    @trainers ||= Trainer.includes :profile
    @away ||= Stage.find_by name: "Away"
    @in_education ||= Stage.find_by name: "In education"
  end

  def organization location
    organization_chart_data = Hash.new
    trainers = trainers location

    trainers.each do |trainer|
      organization_chart_data[trainer] = subjects trainer
    end
    organization_chart_data
  end

  def away_trainees location
    trainees = @trainees.select do |trainee|
      trainee.profile.location_id == location.id && trainee.profile.stage_id == @away.id
    end 
  end

  private
  def trainers location
    @trainers.select do |trainer|
      trainer.profile.location_id == location.id && trainer.profile.stage_id == @in_education.id
    end
  end

  def subjects trainer
    trainees = @trainees.select do |trainee|
      trainee.trainer_id == trainer.id
    end
    subjects = Hash.new
    subjects["free_trainees"] = Array.new
    trainees.each do |trainee|
      user_subject = trainee.user_subjects.find{|user_subject| user_subject.current_progress?}
      if user_subject
        subjects[user_subject.subject] ||= Array.new
        subjects[user_subject.subject] << trainee
      else
        subjects["free_trainees"] << trainee
      end
    end
    subjects
  end
end
