class StaticPagesController < ApplicationController

  def home
    
    @users = User.paginate(page: params[:page])
    @user = User.new
    #@entry  = current_user.entries.build
    #@feed_items = current_user.feed.paginate(page: params[:page])
    
  end

  def help
  end

  def about
  end

  def contact
  end
  def home_after_login


  end
end