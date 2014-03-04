$( ->
  if $('body').attr('data-action') == 'setup_page'
    $('#save-routine').click(CheckUp.Tag.saveFullRoutine)
    $('#new-category-submit').click(CheckUp.Category.newCategoryClick)
    $('[data-category-id]').click(CheckUp.Category.categoryClicked)
    $('#routine-setup').click(CheckUp.Tag.routineClicked)
    $(".sortable").sortable()
    $(".sortable").disableSelection()
  else if $('body').attr('data-action') == 'events_page'
    console.log("Run AJAX function to render event data")
  else if $('body').attr('data-action') == 'routines_page'
    $('#routines-list').click(CheckUp.Routine.routineClicked)

  $('#category-time-show').click(CheckUp.Event.dateClick)
)