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

  @categoryClicked: ->
    if $(event.target).hasClass('delete-category-btn')
      CheckUp.Category.deactivateCategory $(this)
    else if $(event.target).hasClass('add-tag-btn')
      CheckUp.Tag.createTag $(this) # This is the category node to add to
    else if $(event.target).hasClass('delete-tag-btn')
      CheckUp.Tag.deactivateTag $(event.target)

  # This makes a request to update the category to active: false
  # It currently does nothing to deactivate the relevant tags
  @deactivateCategory: ($categoryNode) ->
    categoryId = $categoryNode.attr("data-category-id")
    callback = (response) -> $("[data-category-id='#{response.id}']").remove()
    oneCategoryLeft = ->
      $('[data-category-id]').length == 1
    unless oneCategoryLeft()
      CheckUp.Category.categoryRequest
        id: categoryId
        active: false,
        'PATCH',
        callback

  @newCategoryClick: ->
    $categoryNameForm = $('#new-category-name')
    $allCategoryDivs  = $('[data-category-id]')

    callback = (response) ->
      newCategory = new CheckUp.Category(response)
      newCategory.attachSorted()

    # Don't even send the AJAX request if the name is < 3 characters or 5 cats
    # already exist
    # Put an error handler in here later
    isCategoryValid = ($form, $existingCategories) ->
      $form.val().length >= 3 and $existingCategories.length < 5

    if isCategoryValid($categoryNameForm, $allCategoryDivs)
      CheckUp.Category.categoryRequest
        title: $categoryNameForm.val(),
        'POST',
        callback
      $categoryNameForm.val("")

  # Use this to render a category node from a CheckUpCategory instance
  renderNode: ->
    $categoryDiv  = $('<div/>',
      'data-category-id': this.id
      html: "<p class='category-title'>#{this.title}</p>"
      )
    $deleteButton = $('<button/>',
      class: 'delete-category-btn'
      text: 'Delete Category'
      )
    $addTagButton = $('<button/>',
      class: 'add-tag-btn'
      text: 'Add Tag'
      )
    $addTagForm = $('<input>',
      type: 'text'
      class: 'new-tag-name'
      placeholder: 'Name'
      )
    $tagList = $('<ul/>',
      class: "category-tag-list"
      )
    $categoryDiv.append($deleteButton).append($addTagForm)
    $categoryDiv.append($addTagButton).append($tagList)
    $categoryDiv.click(CheckUp.Category.categoryClicked.bind($categoryDiv))

  attachSorted: ->
    $categoryTitles = $('.category-title')
    $allCategoryDivs = $('[data-category-id]')
    inserted = false
    textValue = (index) ->
      $categoryTitles.eq(index).text()
    for index in [0..$categoryTitles.length]
      if textValue(index) > this.title
        $allCategoryDivs.eq(index).before(this.renderNode())
        inserted = true
        break
    $allCategoryDivs.last().after(this.renderNode()) unless inserted


