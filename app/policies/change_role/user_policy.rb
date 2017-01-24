class ChangeRole::UserPolicy < ApplicationPolicy
  Settings.all_functions.each do |function_name|
    define_method "#{function_name}?" do
      false
    end
  end
end
