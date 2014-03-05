class EventsController < ApplicationController

  def show
    event = Event.find(event_params[:id])
    render json: event
  end

  private
  def event_params
    params.require(:event).permit(:id)
  end
end
