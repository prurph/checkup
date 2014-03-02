class CheckUp.Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for key, value of railsCategory
      this[key] = value

  # This makes an AJAX request to Rails to update a category
  # Rails returns the JSON of the updated category
  updateSelfRequest: (updates={}) ->
    $.ajax(
      url: "/setup/category/#{this.id}"
      type: 'PATCH'
      dataType: 'json'
      data:
        category: updates
      ).done (response) ->
        console.log(response)

  @updateCategoryRequest: (attrs={}) ->
    $.ajax(
      url: "/setup/category/#{attrs.id}"
      type: 'PATCH'
      dataType: 'json'
      data:
        category: attrs
      ).done (response) ->
        console.log(response)

  # This makes an AJAX request to Rails to create a category
  # Rails returns the JSON of the newly created category
  @newCategoryRequest: (attrs={}) ->
    $.ajax(
      url: "/setup/category/"
      type: 'POST'
      dataType: 'json'
      data:
        category: attrs
      ).done (response) ->
        console.log(response)
        $("[data-category-id='#{response.id}']").remove()
        # LATER ENSURE ROUTINE ALSO GETS REDRAWN TO REMOVE CATEGORY'S TAGS

  # This will handle getting the actual input to then pass to the
  # @newCategoryRequest call
  @newCategoryClick: ->
    $categoryNameForm = $('#new-category-name')
    unless $categoryNameForm.val().length <= 3 # Don't submit names < 3 chars
      CheckUp.Category.newCategoryRequest title: $categoryNameForm.val()
      $categoryNameForm.val("")

  @deactivateCategoryClick: ->
    if $(event.target).hasClass('delete-category-btn')
      categoryId = $(this).attr("data-category-id")
      CheckUp.Category.updateCategoryRequest
        id: categoryId
        active: false

# This is for debugging
window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      window.prescott = new CheckUp.Category(response.categories[0])
