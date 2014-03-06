class CheckUp.Error
  @drawError: (message, classType) ->
    $(classType).text(message)
    $(classType).fadeIn('fast')
    if classType == '.notice'
      $(classType).delay(2000).fadeOut('slow')
    else $(classType).delay(3000).fadeOut('slow')


  @eventErrorHandle: (timeArray) ->
    bool = true
    if timeArray.length == 2
      bool = false
    else if $('#to').val() == "" && $('#from').val() != ""
      CheckUp.Error.drawError("Please input ending date!", '.alert')
    else if $('#from').val() == "" && $('#to').val() != ""
      CheckUp.Error.drawError("Please input starting date!", '.alert')
    else
      CheckUp.Error.drawError("Please input date you want to trace!", '.alert')
    bool

  # Don't even send the AJAX request if the name is < 3 characters or 5 cats
  # already exist
  # Put an error handler in here later
  @isCategoryValid: ($form, $existingCategories) ->
    bool = false
    if $form.val().length >= 3 and $existingCategories.length < 5
      bool = true
    else if $existingCategories.length >= 5
      CheckUp.Error.drawError("You have reach your category bound, buy our full version and get unlimit categories!", '.alert')
    else if $form.val().length == 0
      CheckUp.Error.drawError("Please input title for category!", '.alert')
    else if $form.val().length > 0 and $form.val().length < 3
      CheckUp.Error.drawError("Please input a valid title name(at least 3 characters)!", '.alert')
    bool
