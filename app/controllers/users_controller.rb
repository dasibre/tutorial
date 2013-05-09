class UsersController < ApplicationController
  before_filter :authorize, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :is_admin?, only: [:destroy]
  before_filter :signed_in_action, only: [:new, :create]
  
  def index
      @users = User.paginate(page: params[:page])
  end

  def new
	@user = User.new
  end
  
  def show
	@user = User.find(params[:id])
  @microposts = @user.microposts.paginate(page: params[:page])
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
   
   def destroy
       @user = User.find(params[:id])
       if @user.admin?
          redirect_to users_path, notice: "Admin user can not be deleted"
       else
           @user.destroy
           flash[:success] = "User deleted"
           redirect_to users_url
       end
   end
   private
   
   def authorize
       unless signed_in?
              store_location
              redirect_to signin_url, notice: "Please sign in"
       end
   end
   
   def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
   end
   
   def is_admin?
       redirect_to(root_path) unless current_user.admin?
   end
   
   def signed_in_action
       unless !signed_in?
              redirect_to(root_path)
              flash[:notice] = "Please logout to create new account #{view_context.link_to('Signout', signout_path)}".html_safe
       end
   end
end
