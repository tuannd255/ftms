class Trainee < User
  include StiRouting

  scope :traine_in_education, ->{joins(:profile)
    .where("profiles.status_id != 2 and profiles.status_id != 4")}
end
