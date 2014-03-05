class CheckUp.Routine
  # This stores displayed timers as tagId(int): timerText
  @appendTimers: ->
    CheckUp.Routine.DISPLAYED_TIMERS =
      JSON.parse(window.localStorage.displayedTimers) || {updatedAt: "0"}
    # See if the cached timers are from today, and if so append them
    if new Date().getDate() == (CheckUp.Routine.DISPLAYED_TIMERS.updatedAt)

      for tagId, timerText of CheckUp.Routine.DISPLAYED_TIMERS
        $tagTimer = $("[data-routine-tag-id='#{tagId}']").find('.timer')
        tagCurrentEventId = $tagTimer.attr("data-routine-current-event-id")
<<<<<<< HEAD
        debugger
        if tagCurrentEventId == -1
          $tagTimer.text(timerText)
        #else
          $tagTimer.text()
=======
        if not tagCurrentEventId?
          delete CheckUp.Routine.DISPLAYED_TIMERS[tagId]
        # If there is an ongoing event, get the data from Rails
        # data-routine-current-event should only != -1 if we just reloaded the
        # page and had an ongoing event
        else if parseInt(tagCurrentEventId) != -1
          CheckUp.Routine.eventRequest(
            id: tagCurrentEventId,
            # this callback just finds the relevant timer and sets its value to
            # the value from Rails, then it toggles the timer on to keep going
            (response) ->
              tagClickedId = response.tag_id
              $tagClicked  = $("[data-routine-tag-id='#{tagClickedId}']")
              $activeTimer = $tagClicked.find('.timer')
              $activeTimer.attr("data-routine-current-event-id", "-1")
              runTime = (new Date().getTime() -
                new Date(response.created_at).getTime()) / 60000
              $activeTimer.text(CheckUp.Routine.minToString(runTime))
              CheckUp.Routine.toggleTimer($tagClicked, tagClickedId)
            )
        else
          $tagTimer.text(timerText)
>>>>>>> 1026d8b152bd5e8a21de0e161de4430862ca7e9d

  @eventRequest: (attrs={}, callback) ->
    $.ajax(
      url: '/routines/get_event'
      type: 'GET'
      dataType: 'json'
      data:
        event: attrs
    )
    .done (response) ->
      if callback
        callback(response)
      console.log(response)
    .fail (error) ->
      console.log(error)

  @tagEventRequest: (attrs={}, callback) ->
    $.ajax(
      url: '/routines/tag_event/'
      type: 'POST'
      dataType: 'json'
      data:
        tag: attrs
      )
      .done (response) ->
        if callback
          callback(response)
        console.log(response)
      .fail (error) ->
        console.log(error)

  @routineClicked: (event) ->
    $tagClicked  = $(event.target).parents("[data-routine-tag-id]")
    tagClickedId = $tagClicked.attr("data-routine-tag-id")
    CheckUp.Routine.toggleTimer($tagClicked, tagClickedId)
    CheckUp.Routine.tagEventRequest
      id: tagClickedId,
      # Check to see if it's a new day and append timers any time request sent
      CheckUp.Routine.appendTimers

  @stringToMin = (timerText) ->
    matches = timerText.match(/(\d+)/g) || [0]
    minutes = if matches.length is 2
    then parseInt(matches[0] * 60) + parseInt(matches[1])
    else matches[0]

  @minToString = (startTime) ->
    hours = Math.floor (startTime / 60)
    minutes = Math.floor (startTime % 60)
    if hours > 0 then "#{hours} hr #{minutes} min" else
      "#{minutes} min"

  @toggleTimer: ($tagClicked, tagClickedId) ->
    $timer  = $tagClicked.find('.timer')
    $activeTimer = $('[data-timer-id]')

    clearTimeout $activeTimer.attr('data-timer-id')
    $activeTimer.removeAttr('data-timer-id').removeClass('active-tag')

    # Compare DOM nodes to see if user just turned off existing or clicked on
    # a different tag
    unless $activeTimer[0] == $timer[0]
      startTime = parseInt (CheckUp.Routine.stringToMin $timer.text()) || 0
      $timer.text CheckUp.Routine.minToString(startTime)
      $timer.addClass('active-tag')

      tickTock = setInterval ->
        startTime += 1
        $timer.text CheckUp.Routine.minToString(startTime)
        CheckUp.Routine.DISPLAYED_TIMERS[tagClickedId] =
          CheckUp.Routine.minToString(startTime)
        CheckUp.Routine.DISPLAYED_TIMERS.updatedAt = new Date().getDate()
        window.localStorage.displayedTimers =
          JSON.stringify(CheckUp.Routine.DISPLAYED_TIMERS)
<<<<<<< HEAD
        $timer.text minToString(startTime)
      ,60000
=======
      ,60000 # increment by minutes
>>>>>>> 1026d8b152bd5e8a21de0e161de4430862ca7e9d
      $timer.attr('data-timer-id', tickTock)
