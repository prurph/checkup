class PagesController < ApplicationController
  before_action :get_info

  def routines_page
    # Below used just to see what the json looks like
    # render json: {categories: @categories, tags: @tags}
  end

  def setup_page
  end

  def events_page
  end

  def update # This is not implemented, just conceptual/naming
    @categories = params[:categories]
    @categories.each do |json_category|
      rails_category = Category.find_or_create(category: json_category);
      if rails_category.updated_at != json_category.updated_at
        rails_category.update(json_category)
      end
    end
    @tags = params[:tags]
    @events = params[:events] if params[:events].present?
  end

  private
  def get_info
    @categories = Category.where(user: current_user, active: true)
    @tags = Tag.where(category_id: @categories, active: true)
    if params[:events].present?
      @events = Event.where(tag_id: @tags)
    end
  end
end
