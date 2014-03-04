$( ->
  if $('body').attr('data-action') == 'setup_page'
    $('#new-category-submit').click(CheckUp.Category.newCategoryClick)
    $('[data-category-id]').click(CheckUp.Category.categoryClicked)
    $('#routine-setup').click(CheckUp.Tag.routineClicked)
    $(".sortable").sortable()
    $(".sortable").disableSelection()
  if $('body').attr('data-action') == 'events_page'
    console.log("Run AJAX function to render event data")
)
