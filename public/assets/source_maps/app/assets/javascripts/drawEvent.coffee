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
      click: (event) ->
        CheckUp.drawEvent.toggleTagBars(event)
      )
    totalTime = 0
    categoryArray = []
    titleArray = []
    for title, duration of categoryTimes
      $innerCategory = $('<div/>',
        class: "category-inner-bar"
        id: "#{title}"
        "data-duration": duration
        css:
          # If the color doesn't exist (because category has been deleted)
          # Use gray
          "background-color":
            if CheckUp.Category.colors[title]
              "rgb(#{CheckUp.Category.colors[title]})"
            else
              "#95a5a6"
        # click: (event) ->
        #   CheckUp.drawEvent.toggleTagBars(event)
      )
      $categoryEventTitle = $('<p/>',
        class: "category-event-title",
        text: "#{title} #{(duration / 60).toFixed(1)} hr"
        )
      totalTime += duration
      categoryArray.push($innerCategory)
      titleArray.push($categoryEventTitle)
    widthPercent = 0
    leftPosition = 0
    for $category, index in categoryArray
      durationPercent = $category.attr("data-duration") / totalTime * 100
      $category.css(
        # opacity: (durationPercent / 200) + 0.5
        left: "#{leftPosition}%"
        display: "inline-block"
        position: "relative"
        width: "#{durationPercent}%"
        );
      leftPosition += durationPercent
      $singleLine().append(titleArray[index]).append($category).appendTo($allCategories)
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
    $categoryBreakdown.prepend("<div class=tag-overflow></div>")
    for tagName, tagTime of categoryObj
      tagPercentOfCategory = (tagTime / totalCategoryTime) * 100
      opacity = (tagPercentOfCategory / 200) + 0.6
      $tagLi = $('<li/>',
        id: "#{tagName}"
        html: "<p class='ellipsis float-left'>#{tagName}</p>
          <p class='float-right'>#{(tagTime / 60).toFixed(1)}</p>"
        class: 'tag-list-li'
        css:
          width: "#{tagPercentOfCategory}%"
          display: "inline-block"
          "background-color":
            if !CheckUp.Category.colors[categoryTitle]
              "#95a5a6"
            else
              "rgba(#{CheckUp.Category.colors[categoryTitle]},#{opacity})"
        click: (event) ->
          thisHTML = $(this).html()
          $overflow = $(this).closest('ul').prev()
          if $overflow.html() == thisHTML and !$overflow.is(":hidden")
            $overflow.hide()
          else
            $overflow.html("#{thisHTML}").show()
      )
      $categoryUl.append($tagLi)
    $categoryBreakdown.append($categoryUl).hide()
      # appendTo($("##{categoryTitle}").parents('.category-outer-bar'))
    ($("##{categoryTitle}").parents('.category-outer-bar')).after($categoryBreakdown)
    $categoryBreakdown.slideToggle()

  @toggleTagBars: (event) -> # (event.currentTarget is the outer-bar)
    clickedCategoryTitle = $(event.target).children('[id]').attr('id')
    return false if clickedCategoryTitle == "untracked"
    $clickedCategoryTagBar = $("##{clickedCategoryTitle}-tags")
    if $clickedCategoryTagBar?.length > 0
      $clickedCategoryTagBar.slideToggle()
    else
      CheckUp.drawEvent.drawTagBars(clickedCategoryTitle)
