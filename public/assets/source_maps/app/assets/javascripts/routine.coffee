class CheckUp.Routine
  # This stores displayed timers as tagId(int): timerText
  @appendTimers: ->
    CheckUp.Routine.DISPLAYED_TIMERS =
      JSON.parse(window.localStorage.displayedTimers) || {updatedAt: new Date()}
    updatedDate = new Date CheckUp.Routine.DISPLAYED_TIMERS.updatedAt
    # See if the cached timers are from today, and if so append them
    if new Date().getDate() == updatedDate.getDate()

      for tagId, timerText of CheckUp.Routine.DISPLAYED_TIMERS
        $tagTimer = $("[data-routine-tag-id='#{tagId}']").find('.timer')
        tagCurrentEventId = $tagTimer.attr("data-routine-current-event-id")
        if not tagCurrentEventId?
          delete CheckUp.Routine.DISPLAYED_TIMERS[tagId]
        # If there is an ongoing event, get the data from Rails
        # data-routine-current-event should only != -1 if we just reloaded the
        # page and had an ongoing event
        else if parseInt(tagCurrentEventId) != -1
          CheckUp.Routine.eventRequest(
            id: tagCurrentEventId,
            # Must pass timerText or it goes out of scope not sure why I think
            # because for loop completes while waiting on AJAX response?
            timer_text: timerText
            # this callback just finds the relevant timer and sets its value to
            # the value from Rails, then it toggles the timer on to keep going
            (response) ->
              console.log(response)
              activeTagId = response.returnedEvent.tag_id
              $activeTag  = $("[data-routine-tag-id='#{activeTagId}']")
              $activeTimer = $activeTag.find('.timer')
              $activeTimer.attr("data-routine-current-event-id", "-1")
              # Find out how much time has elapsed since last on this page
              runTime = (new Date().getTime() - updatedDate.getTime()) / 60000
              # and add it to the existing timer to find the total time this tag
              # has been ticking today
              runTime = runTime + CheckUp.Routine.stringToMin(response.timerText)

              $activeTimer.text(CheckUp.Routine.minToString(runTime))
              CheckUp.Routine.updateCache(activeTagId, response.timerText)
              CheckUp.Routine.toggleTimer($activeTag, activeTagId)
            )
        else
          $tagTimer.text(timerText)

  @updateCache: (tagId, timerText) ->
    CheckUp.Routine.DISPLAYED_TIMERS[tagId] = timerText
    CheckUp.Routine.DISPLAYED_TIMERS['updatedAt'] = new Date()
    window.localStorage.displayedTimers =
      JSON.stringify(CheckUp.Routine.DISPLAYED_TIMERS)

  @eventRequest: (attrs={}, callback) ->
    $.ajax(
      url: '/routines/get_event'
      type: 'GET'
      dataType: 'json'
      data:
        event: attrs
    )
    .done (response) -> # response is { returnedEvent: ..., timerText: ... }
      if callback
        callback(response)
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
      .done (response) -> # response is { returnedEvent: ..., status: ... }
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
    else parseInt(matches[0])

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
        CheckUp.Routine.updateCache(tagClickedId, $timer.text())
      ,60000 # increment by minutes
      $timer.attr('data-timer-id', tickTock)
