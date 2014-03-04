class CheckUp.Routine
  @routineClicked: (event) ->
    $tagClicked  = $(event.target).parents("[data-routine-tag-id]")
    tagClickedId = $tagClicked.attr("data-routine-tag-id")
    CheckUp.Routine.toggleTimer $tagClicked

  @toggleTimer: ($tagClicked) ->
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
      console.log(startTime)
      $timer.text minToString(startTime)
      $timer.addClass('active-tag')

      tickTock = setInterval ->
        startTime += 10
        $timer.text minToString(startTime)
      , 100 # increment by minutes
      $timer.attr('data-timer-id', tickTock)
