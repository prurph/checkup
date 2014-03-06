class CheckUp.Event

 @dateClick: ->
    CheckUp.Event.reloadInit()
    timeArray = CheckUp.Event.getStartAndEndTime()
    errorResult = CheckUp.Error.eventErrorHandle(timeArray)
    if errorResult == false
      start = timeArray[0].getTime()
      end = timeArray[1].getTime()
      CheckUp.Event.getEventRequest(start, end)
    CheckUp.Event.categoryListEmpty()

  # the start and end time must in timestamp format, use (new Date).getTime()
  @getEventRequest: (start, end) ->
    $.ajax(
      url: "/events"
      type: 'GET'
      dataType: 'json'
      data:
        view_start: start
        view_end: end
      ).done (response) ->
      CheckUp.Event.eventBreakdown = CheckUp.Event.makeEventBreakdown(response.structure)
      CheckUp.Event.categoryTimes = CheckUp.Event.makecategoryTimes(response.structure, response.viewStart, response.viewEnd)
      CheckUp.drawEvent.drawCategoryBars()
      # $('#master-event').prepend($('<h3/>',
      #   class: 'time-period-title'
      #   text: "#{CheckUp.Event.timePeriod[0].toString().slice(0,10)} to
      #     #{CheckUp.Event.timePeriod[1].toString().slice(0,10)}"
      #   )
      # )

  @dateClick: ->
    CheckUp.Event.reloadInit()
    timeArray = CheckUp.Event.getStartAndEndTime()
    if timeArray.length == 2
      start = timeArray[0].getTime()
      end = timeArray[1].getTime()
      CheckUp.Event.getEventRequest(start, end)
      CheckUp.Event.timePeriod = timeArray
    else
      alert("Enter dates!")
    CheckUp.Event.categoryListEmpty()

  @makeEventBreakdown: (structure) ->
    eventBreakdown = {}
    for categoryTitle, tagObject of structure
      eventBreakdown[categoryTitle] = eventBreakdown[categoryTitle] || {}
      for tagName, eventsArray of tagObject
        tagDuration = 0
        for eventItem in eventsArray
          tagDuration += eventItem[2]
        eventBreakdown[categoryTitle][tagName] = tagDuration
    eventBreakdown

  @makecategoryTimes: (structure, viewStart, viewEnd) ->
    categoryTimes = {}
    totalDuration = 0
    eventBreakdown = CheckUp.Event.makeEventBreakdown(structure)
    for categoryTitle, tagsObject of eventBreakdown
      categoryTimes[categoryTitle] = categoryTimes[categoryTitle] || 0
      categoryDuration = 0
      for tagName, tagDuration of tagsObject
        categoryDuration += tagDuration
      categoryTimes[categoryTitle] = categoryDuration
      totalDuration += categoryDuration
    startTime = new Date(viewStart * 1000)
    endTime = new Date(viewEnd * 1000)
    timeDiff = endTime.getTime() - startTime.getTime()
    duration = Math.floor(timeDiff / (1000 * 60))
    categoryTimes["untracked"] = duration - totalDuration
    categoryTimes

  @renderCategoryTime: (structure, start, end) ->
    categoryTime = 0
    tagTime = 0
    timeAllCategory = 0
    eventArray = []
    startTime = new Date(start * 1000)
    endTime = new Date(end * 1000)
    timeDiff = endTime.getTime() - startTime.getTime()
    duration = Math.floor(timeDiff / (1000 * 60))
    dayDuration = Math.ceil(duration / (60 * 24))
    day = "day"
    days = "days"
    #$('#category-time').before("<span>Tracing from #{CheckUp.Event.renderTimeformat(startTime)} to #{CheckUp.Event.renderTimeformat(endTime)}...</span><br><span>Duration is: #{dayDuration} #{if (dayDuration < 2) then day else days}...</span>")
    i = 1
    for category, tagObject of structure
      for tag, tagArray of tagObject
        for eventArray in tagArray
          categoryTime += eventArray[2]
          tagTime += eventArray[2]
          timeAllCategory += eventArray[2]
        # render each of tag time for category
        tagTime = CheckUp.Event.renderTagTime(i, category, tag, tagTime)
        # render each of the event time for a tag
        CheckUp.Event.renderEventTime(tagArray, category, tag)
      $(".category-#{i}").html("#{category} Time: #{categoryTime} minutes in #{duration} minutes, percentage: #{((categoryTime / duration) * 100).toFixed(2)}%" + $(".category-1").html())
      categoryTime = 0
      i++
    $('#category-time').append("<li>Untracked Time: #{duration - timeAllCategory} minutes, percentage: #{(((duration - timeAllCategory) / duration) * 100).toFixed(2)}%</li>")


  @renderTagTime: (categoryIndex, category, tag, tagTime) ->
    $(".category-#{categoryIndex}-tag").append("<li>#{tag} time: #{tagTime} minutes<ol class='#{category}_#{tag}'></ol></li>")
    0
  @renderEventTime: (tagArray, category, tag) ->
    for eventArray in tagArray
      time = new Date(eventArray[0])
      $(".#{category}_#{tag}").append("<li>From #{CheckUp.Event.renderTimeformat(time)} , duration is #{eventArray[2]} minutes </li>")

  @renderTimeformat: (time) ->
    timeStr = time.toString()
    timeStr.split("GMT")[0]

  @reloadInit: ->
    day = new Date()
    yesterday = "#{day.getMonth() + 1}/#{day.getDate() - 1}/#{day.getFullYear()}"
    $(".user-data span").remove()
    $(".user-data br").remove()
    $("#category-time").empty()
    $("#category-time").append("<li class='category-1'><ul class='category-1-tag'></ul></li>")
    $("#category-time").append("<li class='category-2'><ul class='category-2-tag'></ul></li>")
    $("#category-time").append("<li class='category-3'><ul class='category-3-tag'></ul></li>")
    $("#category-time").append("<li class='category-4'><ul class='category-4-tag'></ul></li>")
    # $( "#from" ).datepicker( "option", "maxDate", yesterday );
    # $( "#to" ).datepicker( "option", "maxDate", yesterday );
    # $( "#to" ).datepicker( "option", "minDate", yesterday );
    # $( "#to" ).datepicker( "option", "minDate", $("#single-trace").attr("data-user-create") );

  @categoryListEmpty: ->
    $("#from").val("")
    $("#to").val("")
    $('#cal-1').hide()
    $('#cal-2').hide()

  @getStartAndEndTime: ->
    timeArray = []
    startInput = ""
    endInput = ""
    month = ["Zero", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    if $('#single-trace').attr("data-type") == "single"
      startInput = $("#from").val()
      endArray = startInput.split('/')
      endInput = "#{endArray[0]}/#{(parseInt(endArray[1]) + 1)}/#{endArray[2]}"
      $('#single-trace').attr("data-type", "")
    else if $('#multiple-trace').attr("data-type") == "multiple"
      startInput = $("#from").val()
      endInput = $("#to").val()
      $('#multiple-trace').attr("data-type", "")
    if startInput != "" && endInput != ""
      dateArrayStart = startInput.split('/')
      dateArrayEnd = endInput.split('/')
      dateStart = "#{month[parseInt(dateArrayStart[0])]} #{dateArrayStart[1]}, #{dateArrayStart[2]} 00:00:00"
      dateEnd = "#{month[parseInt(dateArrayEnd[0])]} #{dateArrayEnd[1]}, #{dateArrayEnd[2]} 00:00:00"
      endTime = new Date(dateEnd)
      startTime = new Date(dateStart)
      timeArray.push startTime
      timeArray.push endTime
    timeArray

  @setAttrSingle: ->
    $('#single-trace').attr("data-type", "single")
    $('#multiple-trace').attr("data-type", "")
    $('#cal-1').show()
    $('#cal-2').hide()

  @setAttrMultiple: ->
    $('#multiple-trace').attr("data-type", "multiple")
    $('#single-trace').attr("data-type", "")
    $('#cal-1').show()
    $('#cal-2').show()

  @hideCal: ->
    $('#cal-1').hide()
    $('#cal-2').hide()
