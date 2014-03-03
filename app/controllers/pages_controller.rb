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
    # I'll mark here because the data format convert from Javascript to Ruby, besides,
    # the view_start and view_end must be the format of standard Ruby time format
    view_start = params[:view_start]
    view_end = params[:view_end]
    events = Event.where("created_at BETWEEN :view_start and :view_end OR updated_at BETWEEN :view_start AND :view_end OR (created_at <= :view_start AND updated_at >= :view_end)",
      {view_start: view_start, view_end: view_end})
    @events_time_structure = Event.events_time_period(events, view_start, view_end)
    respond_to do |format|
      format.json { render json: @events_time_structure }
      format.html
    end
  end

  def update # This is not implemented, just conceptual/naming
    @category = Category.find(params[:categoryId])
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
    @categories = Category.where(user: current_user, active: true).order(:title)
    @tags = Tag.where(category_id: @categories, active: true)
    if params[:events].present?
      @events = Event.where(tag_id: @tags)
    end
  end
end
