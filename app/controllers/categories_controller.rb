class CategoriesController < ApplicationController

  def create
    category = Category.create(category_params.merge({user: current_user}))
    render json: category
  end

  def update
    category = Category.find(params[:id])
    category.update(category_params)
    render json: category
  end

  private
  def category_params
    params.require(:category).permit(:active, :color, :created_at,
      :inactive_at, :title, :updated_at)
  end
end
