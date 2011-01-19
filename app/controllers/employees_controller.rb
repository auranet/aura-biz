class EmployeesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :employee_details, [:new, :create]

end
