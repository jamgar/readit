class StoriesController < ApplicationController
  before_action :ensure_login, only: [ :new, :create ]

  def index
    @stories = Story.popular
  end

  def new
    @story = Story.new
  end

  def create
    @story = @current_user.stories.build story_params
    if @story.save
      flash[:notice] = 'Story submission succeeded'
      redirect_to stories_path
    else
      render action: 'new'
    end
  end

  def show
    @story = Story.find(params[:id])
  end

  def bin
    @stories = Story.upcoming
    render action: "index"
  end

  private
    def story_params
      params.require(:story).permit(:name, :link, :description)
    end
end
