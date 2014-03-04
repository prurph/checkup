





class Category
  constructor: (@category) ->
    this.id = @category.id
    this.user_id = @category.user_id
    this.active = @category.active
    this.inactive_at = @category.inactive_at
    this.color = @category.color
    this.title = @category.title
    this.created_at = @category.created_at
    this.updated_at = @category.updated_at

alert("hi");
