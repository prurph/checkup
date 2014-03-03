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
        category:    updates
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
        category:    attrs
      ).done (response) ->
        console.log(response)

  # This will handle getting the actual input to then pass to the
  # @newCategoryRequest call
  @newCategoryClick: ->
    $('#new-tag-name').val()

# This is for debugging
window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      debugger
      window.prescott = new CheckUp.Category(response.categories[0])
