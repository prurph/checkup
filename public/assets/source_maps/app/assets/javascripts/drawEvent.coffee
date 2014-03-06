class CheckUp.drawEvent
  @drawCategoryBars: ->
    categoryTimes = CheckUp.Event.categoryTimes
    $allCategories = $('<div/>',
      class: "all-categories"
      position: "relative"
      html: "" # Clear this if it exists
      )
    $singleLine = ->
      $('<div/>',
      class: "category-outer-bar"
      position: "relative"
      width: "100%"
      )
    totalTime = 0
    categoryArray = []
    for title, duration of categoryTimes
      $innerCategory = $('<div/>',
        class: "category-inner-bar"
        html: "#{title}: #{(duration / 60).toFixed(1)}" # Duration in hours
        id: "#{title}"
        "data-duration": duration
        css:
          "background-color": "rgb(#{CheckUp.Category.colors[title]})"
        click: (event) ->
          CheckUp.drawEvent.toggleTagBars(event)
      )
      totalTime += duration
      categoryArray.push($innerCategory)
    widthPercent = 0
    leftPosition = 0
    for $category in categoryArray
      durationPercent = $category.attr("data-duration") / totalTime * 100
      $category.css(
        # opacity: (durationPercent / 200) + 0.5
        left: "#{leftPosition}%"
        display: "inline-block"
        position: "relative"
        width: "#{durationPercent}%"
        );
      leftPosition += durationPercent
      $singleLine().append($category).appendTo($allCategories)
    $('#master-event').empty()
    $('#master-event').append($allCategories)

  # categoryObj is of the form {tagName: [[event], [event2], [event3]]}
  # categoryTitle is just a string
  @drawTagBars: (categoryTitle) ->
    categoryObj = CheckUp.Event.eventBreakdown[categoryTitle]
    totalCategoryTime = CheckUp.Event.categoryTimes[categoryTitle]
    $categoryBreakdown = $('<div/>',
      class: "tag-list-div"
      position: "relative"
      id: "#{categoryTitle}-tags"
      )
    $categoryUl = $('<ul/>')
    for tagName, tagTime of categoryObj
      tagPercentOfCategory = (tagTime / totalCategoryTime) * 100
      opacity = (tagPercentOfCategory / 200) + 0.5
      $tagLi = $('<li/>',
        id: "#{tagName}"
        html: "#{tagName}: #{(tagTime / 60).toFixed(1)}"
        class: 'tag-list-li'
        css:
          width: "#{tagPercentOfCategory}%"
          display: "inline-block"
          "background-color":
            "rgba(#{CheckUp.Category.colors[categoryTitle]},#{opacity})"
        )
      $categoryUl.append($tagLi)
    $categoryBreakdown.append($categoryUl).
      appendTo($("##{categoryTitle}").parent())

  @toggleTagBars: (event) ->
    clickedCategoryTitle = $(event.target).attr('id')
    return false if clickedCategoryTitle == "untracked"
    $clickedCategoryTagBar = $("##{clickedCategoryTitle}-tags")
    if $clickedCategoryTagBar?.length > 0
      $clickedCategoryTagBar.fadeToggle()
    else
      CheckUp.drawEvent.drawTagBars clickedCategoryTitle


