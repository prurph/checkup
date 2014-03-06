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
    @create_date = current_user.created_at
    # I'll mark here because the data format convert from Javascript to Ruby, besides,
    # the view_start and view_end must be the format of standard Ruby time format
    view_start = Time.at(params[:view_start].to_i / 1000)
    view_end = Time.at(params[:view_end].to_i / 1000)
    events = Event.where("started_at BETWEEN :view_start and :view_end OR ended_at BETWEEN :view_start AND :view_end OR (started_at <= :view_start AND ended_at >= :view_end)",
      {view_start: view_start, view_end: view_end})
    @events_time_structure = Event.events_time_period(events, view_start, view_end)
    respond_to do |format|
      format.json { render json: {structure: @events_time_structure, viewStart: view_start.to_i, viewEnd: view_end.to_i} }
      format.html
    end
  end

  def update # This is not implemented, just conceptual/naming
    @category = Category.find(params[:categoryId])
    render json: @category
    @tags = params[:tags]
    @events = params[:events] if params[:events].present?
  end

  def get_color
    colors = {}
    @categories.each do |category|
      if category.active == true
        colors[category.title] = category.color
      end
      colors[:untracked] = "127,140,141"
    end
    colors[:untracked] = "127,140,141"
    render json: colors
  end

  private
  def update_info
    params.require(:updates).permit(:active, :color, :created_at,
      :inactive_at, :title, :updated_at)
  end

  def get_info
    @categories = Category.where(user: current_user, active: true).order(:title)
    @tags = Tag.where(category_id: @categories, active: true).order(:routine)
    if params[:events].present?
      @events = Event.where(tag_id: @tags)
    end
  end
end
