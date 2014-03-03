class TagsController < ApplicationController

  def set

    # find the now active tag and the user click tag
    tag_to_be_active = Tag.find(params[:id])
    tag_now_active = Tag.where('current_event_id <> -1').first

    # find the active event
    event_now_active = tag_now_active.tags.where(id: tag_now_active.current_event_id) if tag_now_active.present?
    event_to_be_active = nil

    # check if user click the current active event and if this is the first event user click
    if tag_to_be_active != tag_now_active && event_now_active.present?
      # set the duration of current event, this gives the minutes of time in event duration
      event_now_active.duration = Time.now#((Time.now - event_now_active.created_at) / 60).to_i
      event_now_active.save!
      # de-event the active tag
      tag_now_active.current_event_id = -1
      tag_now_active.save!
    end

    if tag_to_be_active != tag_now_active
      event_to_be_active = Event.create(tag: tag_to_be_active)
      # active the to-be-active tag
      tag_to_be_active.current_event_id = event_to_be_active.id
      tag_to_be_active.save!
    end

    render json: (event_to_be_active.present?) ? event_to_be_active : event_now_active
  end

end
