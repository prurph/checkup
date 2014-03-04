$( ->
  if $('body').attr('data-action') == 'setup_page'
    $('#save-routine').click(CheckUp.Tag.saveFullRoutine)
    $('#new-category-submit').click(CheckUp.Category.newCategoryClick)
    $('[data-category-id]').click(CheckUp.Category.categoryClicked)
    $('#routine-setup').click(CheckUp.Tag.routineClicked)
    $(".sortable").sortable()
    $(".sortable").disableSelection()
  else if $('body').attr('data-action') == 'events_page'


  else if $('body').attr('data-action') == 'routines_page'
    $('#routines-list').click(CheckUp.Routine.routineClicked)
<<<<<<< HEAD
    # Append any active timers from today
    CheckUp.Routine.appendTimers()
=======

  $('#category-time-show').click(CheckUp.Event.dateClick)
>>>>>>> 3069592a29d21ad49bcc48949970fac349ccdbf8
)
