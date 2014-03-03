class CheckUp.Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for own key, value of railsCategory
      this[key] = value

  # This is used for all AJAX requests to create/deactivate/update a category
  # Pass an object of attributes, an HTTP method type ('GET') and a callback
  @categoryRequest: (attrs={}, type, callback) ->
    $.ajax(
      url: "/setup/category/"
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

  # This makes a request to update the category to active: false
  # It currently does nothing to deactivate the relevant tags
  @deactivateCategoryClick: ->
    categoryId = $(this).attr("data-category-id")
    callback = (response) -> $("[data-category-id='#{response.id}']").remove()

    if $(event.target).hasClass('delete-category-btn')
      CheckUp.Category.categoryRequest
        id: categoryId
        active: false,
        'PATCH',
        callback

  @newCategoryClick: ->
    $categoryNameForm = $('#new-category-name')
    callback = (response) ->
      newCategory = new CheckUp.Category(response)
      #$categoryDivs = $('[data-category-id]')
      #$categoryDivs.append newCategory.renderNode()
      newCategory.attachSorted()

    unless $categoryNameForm.val().length <= 3 # Don't submit names < 3 chars
      CheckUp.Category.categoryRequest
        title: $categoryNameForm.val(),
        'POST',
        callback
      $categoryNameForm.val("")

  # Use this to render a category node from a CheckUpCategory instance
  renderNode: ->
    $categoryDiv  = $('<div/>',
      'data-category-id': this.id
      html: "<p>#{this.title}</p>"
      )
    $deleteButton = $('<button/>',
      class: "delete-category-btn"
      text: "Delete Category"
      )
    $categoryDiv.append($deleteButton)

  attachSorted: ->
    $categoryDivs = $('[data-category-id]')
    textValue = (index) ->
      $categoryDivs.eq(index).text()
    for index in $categoryDivs.length
      debugger
      if textValue(index) > this.title
        $categoryDivs.eq(index).before(this.renderNode())

# This is for debugging
window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      debugger
      window.prescott = new CheckUp.Category(response.categories[0])


