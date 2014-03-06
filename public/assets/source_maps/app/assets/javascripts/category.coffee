class CheckUp.Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for own key, value of railsCategory
      this[key] = value

  @getCategoryColor: ->
    $.ajax(
      url: "/setup/color"
      type: "GET"
      dataType: 'json'
      )
      .done (colors) ->
        CheckUp.Category.colors = colors

  @defaultColors: ["52,152,219", "230,126,34", "230,126,34",
    "241,196,15", "142,68,73"]

  @setSetupCategoryDivColors: ->
    # CheckUp.Category.getCategoryColor
    takenColors = []
    for categoryTitle, color of CheckUp.Category.colors
      $categoryDiv = $("[data-category-title='#{categoryTitle}']")
      if $categoryDiv?
        $categoryDiv.css("background-color", "rgb(#{color})")
        takenColors.push(color)
    # set the defaultColors to only have the not taken ones
    CheckUp.Category.defaultColors = $(CheckUp.Category.defaultColors)
      .not(takenColors).get()


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

  @categoryClicked: (event) ->
    event.preventDefault()
    if $(event.target).hasClass('delete-category-btn')
      CheckUp.Category.deactivateCategory $(this)
    else if $(event.target).hasClass('add-tag-btn')
      CheckUp.Tag.createTag $(this) # This is the category node to add to
    else if $(event.target).hasClass('delete-tag-btn')
      CheckUp.Tag.deactivateTag $(event.target)
    else if $(event.target).hasClass('routine-add-tag-btn')
      CheckUp.Tag.addToRoutine $(event.target)
    else if $(event.target).hasClass('category-title')
      CheckUp.Category.toggleDetails $(event.target)
    return false;

  # This makes a request to update the category to active: false
  # It currently does nothing to deactivate the relevant tags
  @deactivateCategory: ($categoryNode) ->
    categoryId = $categoryNode.attr("data-category-id")
    callback = (response) ->
      $deletedCategory = $("[data-category-id='#{response.id}']")
      # Parse rgba(xx, xxx, xxx) into "xx,xxx,xxx" and stick it back in colors
      CheckUp.Category.defaultColors.push(
        $deletedCategory.css("background-color").slice(4,-1).split(" ").join("")
      )
      # $("[data-category-id='#{response.id}']").remove()
      $deletedCategory.remove()
    oneCategoryLeft = ->
      $('[data-category-id]').length == 1
    unless oneCategoryLeft()
      CheckUp.Category.categoryRequest
        id: categoryId
        active: false,
        'PATCH',
        callback

  @newCategoryClick: ->
    event.preventDefault()
    $categoryNameForm = $('#new-category-name')
    $allCategoryDivs  = $('[data-category-id]')

    callback = (response) ->
      newCategory = new CheckUp.Category(response)
      newCategory.attachSorted()
      CheckUp.Category.defaultColors.splice(0,1)

    # Don't even send the AJAX request if the name is < 3 characters or 5 cats
    # already exist
    # Put an error handler in here later
    isCategoryValid = ($form, $existingCategories) ->
      $form.val().length >= 3 and $existingCategories.length < 5

    if isCategoryValid($categoryNameForm, $allCategoryDivs)
      CheckUp.Category.categoryRequest
        title: $categoryNameForm.val(),
        color: CheckUp.Category.defaultColors[0]
        'POST',
        callback
      $categoryNameForm.val("")
    return false;

  @toggleDetails: ($eventTarget) ->
    $eventTarget.siblings().fadeToggle()
    return false;

  # Use this to render a category node from a CheckUpCategory instance
  renderNode: ->
    $categoryDiv  = $('<div/>',
      'data-category-id': this.id
      class: "main-category"
      html: "<p class='category-title'>#{this.title}</p>"
      css:
        "background-color": "rgb(#{this.color}"
      )
    $deleteButton = $('<button/>',
      class: 'btn delete-category-btn routine-btn'
      html: "Delete Category"
      )
    $addTagButton = $('<button/>',
      class: 'btn add-tag-btn routine-btn'
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
    $categoryDiv.append($tagList).append($addTagForm).
      append($addTagButton).append($deleteButton)
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
