class CheckUp.drawEvent

  @drawCategoryBars: (categoryTimes) ->
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
        html: "#{title}"
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
        opacity: (durationPercent / 100)/2 + 0.5
        left: "#{leftPosition}%"
        display: "inline-block"
        position: "relative"
        width: "#{durationPercent}%"
        );
      leftPosition += durationPercent
      $singleLine().append($category).appendTo($allCategories)
    $('#draw-shit').append($allCategories)
