class CheckUp.Event

  @getEventRequest: (start, end) ->
    $.ajax(
      url: "/events"
      type: 'POST'
      dataType: 'json'
      data:
        view_start: start
        view_end: end
      ).done (response) ->
      CheckUp.Event.renderCategoryTime(response.structure, response.viewStart, response.viewEnd)

  @dateClick: ->
    CheckUp.Event.getEventRequest(startTime, endTime)

  @renderCategoryTime: (structure, start, end) ->
    categoryTime = 0
    tagTime = 0
    timeAllCategory = 0
    eventArray = []
    startTime = new Date(start * 1000)
    endTime = new Date(end * 1000)
    timeDiff = endTime.getTime() - startTime.getTime()
    duration = Math.floor(timeDiff / (1000 * 60))
    for category, tagObject of structure
      i = 1
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
      $(".#{category}_#{tag}").append("<li>From #{eventArray[0]} To #{eventArray[1]}, duration is #{eventArray[2]} </li>")



  # debugging window request
window.req = ->
  time = new Date("March 1, 2014 12:00:00")
  time2 = new Date("October 13, 2013 11:13:00")
  end = time.getTime()
  start = time2.getTime()
  $.ajax(
    url: '/events'
    type: 'GET'
    dataType: 'json'
    data:
        view_start: start
        view_end: end
    ).done (response) ->
      debugger
      CheckUp.Event.renderCategoryTime(response.structure, response.viewStart, response.viewEnd)

