$( ->
  $('#new-category-submit').click(CheckUp.Category.newCategoryClick)
  $('[data-category-id]').click(CheckUp.Category.categoryClicked)
)
