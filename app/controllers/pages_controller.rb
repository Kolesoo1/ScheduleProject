class PagesController < ApplicationController
  def home
    if User.any?
      @users = User.all
    end
  end
end
