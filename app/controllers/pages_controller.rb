class PagesController < ApplicationController
  before_action :get_info

  def routines_page
    @active_sort_tags = @tags.where('routine > -1').order(:routine)
  end

  def setup_page
    respond_to do |format|
      format.json { render json: {categories: @categories, tags: @tags} }
      format.html
    end
  end

  def events_page
  end

  def update # This is not implemented, just conceptual/naming
    @category = Category.find(params[:categoryId])
    binding.pry
    render json: @category
    @tags = params[:tags]
    @events = params[:events] if params[:events].present?
  end

  private
  def update_info
    params.require(:updates).permit(:active, :color, :created_at,
      :inactive_at, :title, :updated_at)
  end

  def get_info
    @categories = Category.where(user: current_user, active: true)
    @tags = Tag.where(category_id: @categories, active: true)
    if params[:events].present?
      @events = Event.where(tag_id: @tags)
    end
  end
end
