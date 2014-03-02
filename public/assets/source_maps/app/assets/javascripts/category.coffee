class Category
  # Get railsCategory object and create it in JS
  constructor: (railsCategory) ->
    for key, value of railsCategory
      this[key] = value

  railsUpdate: (updates={}) ->
    $.ajax(
      url: "/setup/category/#{this.id}"
      type: 'PATCH'
      dataType: 'json'
      data:
        updates:    updates
      ).done (response) ->
        console.log(response)


window.req = ->
  $.ajax(
    url: '/setup'
    type: 'GET'
    dataType: 'json'
    ).done (response) ->
      window.prescott = new Category(response.categories[0])
