class StaticPagesController < ApplicationController
  def home
	 @micropost = current_user.microposts.build if signed_in?
  end

  def help
	  
  end

  def about
	#@title = 'About us'
  end
  
  def contact
  end
end
