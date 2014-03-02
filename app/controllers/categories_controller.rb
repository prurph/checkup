class CategoriesController < ApplicationController

  def update
    category = Category.find(params[:id])
    category.update(update_info)
    render json: category
  end

  private
  def update_info
    params.require(:updates).permit(:active, :color, :created_at,
      :inactive_at, :title, :updated_at)
  end
end
