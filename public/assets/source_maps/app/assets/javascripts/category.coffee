class Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for key, value of railsCategory
      this[key] = value

  railsUpdate: (updates={}) ->
    $.ajax(
      url: '/setup'
      type: 'POST'
      dataType: 'json'
      data:
        categoryId: this.id
        updates:    updates
      ).done (response) ->
        console.log(response)
        console.log("hey")


window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      window.prescott = new Category(response.categories[0])
