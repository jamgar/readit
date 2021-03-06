class VotesController < ApplicationController
  before_action :ensure_login
  def create
    @story = Story.find(params[:story_id])
    if @vote = @story.votes.create(user: @current_user)
      respond_to do |format|
        format.html { redirect_to @story, notice: 'Vote was Successfully create.' }
        format.js {}
      end
    end
  end
end
