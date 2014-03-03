class CheckUp.Tag
  constructor: (railsCategory) ->
    for key, value of railsCategory
      this[key] = value

  @setEventRequest: (id) ->
    $.ajax(
      url: "/routines/set-event/#{id}"
      type: 'POST'
      dataType: 'json'
      ).done (response) ->
        # some CSS issue for changing the color of this tag
        $("##{response.tag_id}").css("background-color", "grey")

  @tagClick: ->
    CheckUp.Tag.setEventRequest(this.id)
