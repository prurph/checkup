$( ->
  if $('body').attr('data-action') == 'setup_page'
    $('#new-category-submit').click(CheckUp.Category.newCategoryClick)
    $('[data-category-id]').click(CheckUp.Category.categoryClicked)
    $('#routine-setup').click(CheckUp.Tag.routineClicked)
    $(".sortable").sortable()
    $(".sortable").disableSelection()
  else if $('body').attr('data-action') == 'events_page'


  else if $('body').attr('data-action') == 'routines_page'
    $('#routines-list').click(CheckUp.Routine.routineClicked)
    # Append any active timers from today
    CheckUp.Routine.appendTimers()
)
