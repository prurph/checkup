class CheckUp.Tag
  # Get railsCategory object and create it in JS
  constructor: (railsTag) ->
    for own key, value of railsTag
      this[key] = value

  @tagRequest: (attrs={}, type, callback) ->
    $.ajax(
      url: "/setup/tag/"
      type: type
      dataType: 'json'
      data:
        category: attrs
      )
      .done (response) ->
        if callback
          callback(response)
      .fail (error) ->
        console.log(error)

  @createTag: (attrs) ->
    # this is jQuery node of category to add to
    $categoryId = this.attr("data-category-id")
    $tagNameForm = this.find(".new-tag-name")

    CheckUp.Tag.tagRequest
      name: $tagNameForm.val()
      category_id: $categoryId,
      'POST',
      (response) -> console.log(response)
