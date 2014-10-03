class SessionsController < ApplicationController
  
  def create
  	employee = Employee.find_by(email: params[:email].downcase)
  	if employee && employee.authenticate(params[:password])

  	else
  		flash.now[:danger] = "Invalid email or password."
  		render 'new'
  	end
  end

  def new
  end

end
