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
        debugger
        if tagCurrentEventId == -1
          $tagTimer.text(timerText)
        #else
          $tagTimer.text()

  @tagEventRequest: (attrs={}, type, callback) ->
    $.ajax(
      url: '/routines/tag_event/'
      type: type
      dataType: 'json'
      data:
        tag: attrs
      )
      .done (response) ->
        if callback
          callback(response)
      .fail (error) ->
        console.log(error)

  @routineClicked: (event) ->
    $tagClicked  = $(event.target).parents("[data-routine-tag-id]")
    tagClickedId = $tagClicked.attr("data-routine-tag-id")
    CheckUp.Routine.toggleTimer($tagClicked, tagClickedId)
    CheckUp.Routine.tagEventRequest
      id: tagClickedId,
      'POST',
      # Check to see if it's a new day and append timers any time request sent
      CheckUp.Routine.appendTimers

  @stringToMin = (timerText) ->
    matches = timerText.match(/(\d+)/g) || [0]
    minutes = if matches.length is 2
    then parseInt(matches[0] * 60) + parseInt(matches[1])
    else matches[0]
  @minToString = (startTime) ->
    hours = Math.floor (startTime / 60)
    minutes = startTime % 60
    if hours > 0 then "#{hours} hr #{minutes} min" else
      "#{minutes} min"


  @toggleTimer: ($tagClicked, tagClickedId) ->
    $timer  = $tagClicked.find('.timer')
    $activeTimer = $('[data-timer-id]')
    # stringToMin = (timerText) ->
    #   matches = timerText.match(/(\d+)/g) || [0]
    #   minutes = if matches.length is 2
    #   then parseInt(matches[0] * 60) + parseInt(matches[1])
    #   else matches[0]
    # minToString = (startTime) ->
    #   hours = Math.floor (startTime / 60)
    #   minutes = startTime % 60
    #   if hours > 0 then "#{hours} hr #{minutes} min" else
    #     "#{minutes} min"

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
        $timer.text minToString(startTime)
      ,60000
      $timer.attr('data-timer-id', tickTock)
