class TagsController < ApplicationController

  def set
    # find the now active tag and the user click tag
    tag_to_be_active = Tag.find(params[:id])
    tag_now_active = Tag.where('current_event_id <> -1').first

    # find the active event
    event_now_active = tag_now_active.tags.where(id: tag_now_active.current_event_id) if tag_now_active.present?
    event_to_be_active = nil

    # check if user click the current active event and if this is the first event user click
    event_to_be_active = Tag.handleRoutine(tag_to_be_active, tag_now_active, event_now_active, event_to_be_active)

    render json: (event_to_be_active.present?) ? event_to_be_active : event_now_active
  end
end
