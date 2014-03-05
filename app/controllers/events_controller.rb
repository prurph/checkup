class EventsController < ApplicationController

  def show
    event = Event.find(event_params[:id])
    render json: { returnedEvent: event, timerText: event_params[:timer_text] }
  end

  private
  def event_params
    params.require(:event).permit(:id, :timer_text)
  end
end
