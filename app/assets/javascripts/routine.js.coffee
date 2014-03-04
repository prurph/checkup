class CheckUp.Routine
  # This stores displayed timers as tagId(int): timerText
  window.localStorage.displayedTimers ||= ""
  @DISPLAYED_TIMERS = JSON.parse(window.localStorage.displayedTimers) || {}
  @appendTimers: ->
    unless new Date().getDate == this.DISPLAYED_TIMERS.updatedDate
      for tagId, timerText of this.DISPLAYED_TIMERS
        $tagTimer = $("[data-routine-tag-id='#{tagId}']").find('.timer')
        $tagTimer.text(timerText)

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
      id: tagClickedId

  @toggleTimer: ($tagClicked, tagClickedId) ->
    $timer  = $tagClicked.find('.timer')
    $activeTimer = $('[data-timer-id]')
    stringToMin = (timerText) ->
      matches = timerText.match(/(\d+)/g) || [0]
      minutes = if matches.length is 2
      then parseInt(matches[0] * 60) + parseInt(matches[1])
      else matches[0]
    minToString = (startTime) ->
      hours = Math.floor (startTime / 60)
      minutes = startTime % 60
      if hours > 0 then "#{hours} hr #{minutes} min" else
        "#{minutes} min"

    clearTimeout $activeTimer.attr('data-timer-id')
    $activeTimer.removeAttr('data-timer-id').removeClass('active-tag')

    # Compare DOM nodes to see if user just turned off existing or clicked on
    # a different tag
    unless $activeTimer[0] == $timer[0]
      startTime = parseInt (stringToMin $timer.text()) || 0
      $timer.text minToString(startTime)
      $timer.addClass('active-tag')

      tickTock = setInterval ->
        startTime += 1
        $timer.text minToString(startTime)
        CheckUp.Routine.DISPLAYED_TIMERS[tagClickedId] = minToString(startTime)
        window.localStorage.displayedTimers =
          JSON.stringify(CheckUp.Routine.DISPLAYED_TIMERS)
      ,60000 # increment by minutes
      $timer.attr('data-timer-id', tickTock)
