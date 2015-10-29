class ProjectsController < ApplicationController
  def index
    @user_preference = UserPreference.first
  end
end
