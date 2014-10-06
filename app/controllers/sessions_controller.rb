class SessionsController < ApplicationController
  
  def create
  	user = Employee.find_by(email: params[:email].downcase)
  	if user && user.authenticate(params[:password])
  		log_in(user)
  		redirect_to user
  	else
  		flash.now[:danger] = "Invalid email or password."
  		render 'new'
  	end
  end

  def new
  end

  def destroy
  	log_out
  	redirect_to login_path
  end

end
