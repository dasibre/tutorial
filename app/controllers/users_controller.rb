class UsersController < ApplicationController
  before_filter :authorize, only: [:edit, :update]
  def index
  end

  def new
	@user = User.new
  end
  
  def show
	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
    	if @user.save
       sign_in @user
	      flash[:success]= "Welcome to Rails Tutorial"
        redirect_to @user
	     else
	         render 'new'
       end
  end
  
   def edit
    @user = User.find(params[:id])
   end
   
   def update
       @user = User.find(params[:id])
       if @user.update_attributes(params[:user])
           flash[:success] = "Profile successfully updated"
           sign_in @user
           redirect_to @user
       else
         render 'edit'
       end
   end
   
   private
   
   def authorize
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
      
   end
end
