class Admin::UserFunctionPolicy < ApplicationPolicy
  attr_reader :user, :controller, :action, :user_functions, :record

  def initialize user, args
    @user = user
    @controller_name = args[:controller]
    @action = args[:action]
    @record = args[:record]
  end

  Settings.all_functions.each do |function_name|
    define_method "#{function_name}?" do
      @user.is_a? Admin
    end
  end

  # neu co class = admin => co tat ca cac quyen
  # neu class = trainer && role_type = admin => van la trainer nhung co role_function la cua admin
    #=> check user_function
end
