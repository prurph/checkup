class TagsController < ApplicationController

  def tag_event
    # find the now active tag and the user click tag
    tag_to_be_active = Tag.find(tag_params[:id])
    tag_now_active = Tag.where('current_event_id <> -1').first

    # find the active event
    event_now_active = tag_now_active.events.where(id: tag_now_active.current_event_id).first if tag_now_active.present?
    event_to_be_active = nil

    # check if user click the current active event and if this is the first event user click
    event_to_be_active = Tag.handleRoutine(tag_to_be_active, tag_now_active, event_now_active, event_to_be_active)

    # If user clicked to stop current event only, event_now_active is actually
    # the paused event
    if event_to_be_active.present?
      render json:
        { event: event_to_be_active, status: "New event started." }
    else
      render json:
        { event: event_now_active,
          status: "Stopped existing event. No currently active event." }
    end
  end

  def create
    tag = Tag.create!(tag_params)
    render json: tag
  end

  def update
    tag = Tag.find(params[:tag][:id])
    tag.update!(tag_params)
    render json: tag
  end

  def save_routine
    tag_ids_ordered_by_routine = routine_params
    tag_ids_ordered_by_routine.each_with_index do |tag_id, routine_value|
      Tag.find(tag_id).update(routine: routine_value)
    end
    render json: { status: "Routine updated" }
  end

  private
  def tag_params
    params.require(:tag).permit(:id, :category_id, :active, :routine, :name,
      :current_event_id)
  end
  def routine_params
    params.require(:tag_ids_ordered_by_routine)
  end
end
