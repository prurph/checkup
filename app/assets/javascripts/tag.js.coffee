class CheckUp.Tag
  constructor: (railsTag) ->
    for own key, value of railsTag
      this[key] = value

  # This is Yiyang's
  @setEventRequest: (id) ->
    $.ajax(
      url: "/routines/set-event/#{id}"
      type: 'POST'
      dataType: 'json'
      ).done (response) ->
        # some CSS issue for changing the color of this tag
        $("##{response.tag_id}").css("background-color", "grey")

  @tagRequest: (attrs={}, type, callback) ->
    $.ajax(
      url: "/setup/tag/"
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

  @routineClicked: ->
    if $(event.target).hasClass('routine-remove-tag-btn')
      CheckUp.Tag.removeFromRoutine $(event.target)

  @deactivateTag: ($eventTarget) ->
    # Find the tag list item based on the click target
    $tagLi = $eventTarget.parents('[data-tag-id]')
    tagId = $tagLi.attr("data-tag-id")
    callback = (response) -> $("[data-tag-id='#{response.id}']").remove()
    CheckUp.Tag.tagRequest
      id: tagId
      active: false,
      'PATCH',
      callback

  @createTag: ($category) ->
    # $category is jQuery category node to add on to
    $categoryId = $category.attr("data-category-id")
    $tagNameForm = $category.find(".new-tag-name")
    callback = (response) ->
      newTag = new CheckUp.Tag(response)
      newTag.attachToCategory()
      $tagNameForm.val("")

    isTagValid = ($form) ->
      $form.val().length >= 3

    if isTagValid($tagNameForm)
      CheckUp.Tag.tagRequest
        name: $tagNameForm.val()
        category_id: $categoryId,
        'POST',
        callback

  @addToRoutine: ($eventTarget) ->
    $tagLi = $eventTarget.parents('[data-tag-id]')
    tagId = $tagLi.attr('data-tag-id')
    $routineList = $('data-routine-tag-id')
    callback = (response) ->
      newRoutine = new CheckUp.Tag(response)
      newRoutine.addToRoutine()
      # Remove the 'Add to Routine' button for this tag
      $("[data-tag-id='response.id']").find('.routine-add-tag-btn').remove()

    CheckUp.Tag.tagRequest
      id: tagId
      routine: $routineList.length, #Set to the end of the routine
      'PATCH',
      callback

  @removeFromRoutine: ($eventTarget) ->
    $tagLi = $eventTarget.parents('[data-routine-tag-id]')
    tagId = $tagLi.attr('data-routine-tag-id')
    callback = (response) -> $("[data-routine-tag-id='#{response.id}']").remove()

    CheckUp.Tag.tagRequest
      id: tagId
      routine: -1
      'PATCH'
      callback

  attachToCategory: ->
    $tagLi = $('<li/>',
      'data-tag-id': this.id
      html: "<p class='tag-title'>#{this.name}</p>"
    )
    $deleteButton = $('<button/>',
      class: 'delete-tag-btn'
      text: 'Delete Tag'
    )
    $addRoutineButton = $('<button/>',
      class: 'routine-add-tag-btn'
      text: 'Add to Routine'
    )
    $tagLi.append($deleteButton).append($addRoutineButton)
    # Find the matching category and append the tag list item to it in order
    $thisCategory = $("[data-category-id='#{this.category_id}']")
    $tagNames = $thisCategory.find('.tag-title')
    $categoryTagListItems = $thisCategory.find('.category-tag-list li')
    inserted = false
    textValue = (index) ->
      $tagNames.eq(index).text()

    # If there are no tags, append directly to the list
    if $tagNames.length == 0
      $thisCategory.find('.category-tag-list').append($tagLi)
    # Otherwise alphabetically insert
    else
      for index in [0..$tagNames.length]
        if textValue(index) > this.name
          $categoryTagListItems.eq(index).before($tagLi)
          inserted = true
          break
      $categoryTagListItems.last().after($tagLi) unless inserted

  addToRoutine: ->
    # Adding something to the routine always puts it at the end
    $lastRoutineLi = $('[data-routine-tag-id]').last()
    $tagLi = $('<li/>',
      'data-routine-tag-id': this.id
      html: "<p class='routine-tag-title'>#{this.name}</p>"
    )
    $removeButton = $('<button/>',
      class: 'routine-remove-tag-btn'
      text: 'Remove from Routine'
    )
    $tagLi.append($removeButton).appendTo($lastRoutineLi)

