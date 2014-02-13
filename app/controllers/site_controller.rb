class SiteController < ApplicationController
  def overview
    @developers = Developer.all
    @projects = Project.all
  end
end
