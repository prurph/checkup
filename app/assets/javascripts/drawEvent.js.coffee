class CheckUp.drawEvent
  @drawCategoryBars: (categoryName) ->
    categoryTimes = CheckUp.Event.eventBreakdown[categoryName]
    $allCategories = $('<div/>',
      class: "all-categories"
      position: "relative"
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
          "background-color": CheckUp.Category.colors["#{title}"]
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
    $('#draw-shit').append($allCategories)

  # categoryObj is of the form {tagName: [[event], [event2], [event3]]}
  # categoryTitle is just a string
  @drawTagBars: (categoryTitle, categoryObj) ->
    totalCategoryTime = CheckUp.Event.categoryTimes[categoryTitle]
    $categoryBreakdown = $('<div/>',
      class: "tag-list-div"
      position: "relative"
      )
    $categoryUl = $('<ul/>')
    for tagName, eventArray of categoryObj
      totalTagTime = 0
      for singleEvent in eventArray
        totalTagTime += singleEvent[2] # [start, end, duration]
      console.log(totalTagTime)
      console.log(totalCategoryTime)
      tagPercentOfCategory = totalTagTime / totalCategoryTime * 100
      opacity = (tagPercentOfCategory / 200) + 0.5
      $tagLi = $('<li/>',
        id: "#{tagName}"
        html: "#{tagName}: #{(totalTagTime / 60).toFixed(1)}"
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
