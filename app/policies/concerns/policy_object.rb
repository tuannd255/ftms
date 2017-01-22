module PolicyObject
  Settings.functions.each do |function_name|
    define_method "#{function_name}?" do
      !@user.is_a?(Trainee)
    end
  end

  def new?
    create?
  end

  def edit?
    update?
  end
end
