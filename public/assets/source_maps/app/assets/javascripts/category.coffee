class CheckUp.Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for key, value of railsCategory
      this[key] = value

  updateSelfReq: (updates={}) ->
    $.ajax(
      url: "/setup/category/#{this.id}"
      type: 'PATCH'
      dataType: 'json'
      data:
        category:    updates
      ).done (response) ->
        console.log(response)

  @newCategoryReq: (attrs={}) ->
    $.ajax(
      url: "/setup/category/"
      type: 'POST'
      dataType: 'json'
      data:
        category:    attrs
      ).done (response) ->
        console.log(response)

  @newCategoryClick: ->
    $ '#new-tag-name'

# This is for debugging
window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      window.prescott = new Category(response.categories[0])
