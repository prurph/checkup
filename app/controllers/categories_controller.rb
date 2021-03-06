class CategoriesController < ApplicationController

  def create
    category = Category.create!(category_params.merge({user: current_user}))
    render json: category
  end

  def update
    category = Category.find(params[:category][:id])
    if params[:category][:active] == "false"
      category.deactivate
    end
    category.update!(category_params)
    render json: category
  end

  private
  def category_params
    params.require(:category).permit(:id, :active, :color, :created_at,
      :inactive_at, :title, :updated_at)
  end
end
