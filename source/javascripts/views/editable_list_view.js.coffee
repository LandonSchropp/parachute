###
A view that allows a user to view and edit a list of students.
###
Parachute.EditableListView = Ember.View.extend({

  # Configurate the editable list HTML.
  tagName: "ul"
  classNames: [ "editable-list" ]
  templateName: "editable_list"

  # Remove the content from inputs that only contain whitespace when they're blurred.
  focusOut: (event) ->

    event.target.value = "" if /^\s*$/.test(event.target.value)
    @_update()

  # Bind to the keydown event and listen for the delete and return keys. If the user presses 
  # return, insert a new item. If the user presses delete and the current item is empty, delete it.
  keyDown: (event, params) ->

    keyCode = event.keyCode or event.which
    currentIndex = @_currentIndex()
    inputs = @_inputs()

    # ignore the event unless an element is selected
    return unless currentIndex?

    # if the delete key is pressed down
    if (keyCode is 8 or keyCode is 46)

      # if the text field is empty and the list has more than one value in it
      if event.target.value is "" and inputs.length > 1

        # remove the element unless it's the last element and the previous element is not empty
        unless currentIndex is inputs.length - 1 and inputs[currentIndex - 1].value isnt ""
          @get("controller").removeAt(currentIndex)

        # select the previous element and prevent the default behavior
        @_selectAt(if currentIndex is 0 then 0 else currentIndex - 1)
        event.preventDefault()

    # insert an item if the enter key is pressed down
    if keyCode is 13

      # unless this is the second to the last item, add a new item
      if currentIndex isnt inputs.length - 2
        @get("controller").insertEmptyStudent(currentIndex + 1) 

      # select the next item after the insertion has propagated
      Ember.run.next(this, -> @_selectAt(currentIndex + 1))

      # BUG FIX: This fixes a problem where the enter button triggers an event for the input 
      # elements in IE.
      event.preventDefault()

    # select the previous item if the up arrow is pressed
    if keyCode is 38

      @_selectAt(currentIndex - 1)
      event.preventDefault()

    # select the next item if the down arrow is pressed
    if keyCode is 40

      @_selectAt(currentIndex + 1)
      event.preventDefault()

  # Ensure the list is always kept up to date.
  keyUp: -> @_update()
  change: -> @_update()

  # Retrieves the jQuery object representing the input elements in this editable list.
  _inputs: -> @$().find("input")

  # Returns the index of the currently active element in this lis, or -1 if no elements are active.
  #
  # HACK: I couldn't find a better way to retrieve the current index using Ember. Ideally, Ember 
  # would pass along the model with the event data, and I could iterate over the array. This method 
  # should be removed when I find a better way to accomplish this.
  _currentIndex: -> @_inputs().index(document.activeElement)

  # Selects the editable element at the provided index. If the index is out of bounds, this method 
  # does nothing.
  _selectAt: (index) ->

    inputs = @_inputs()

    # select the element at the end
    $(inputs[index]).caret(inputs[index].value.length)

  # Ensures the editable list view is always current. This method should be called by any event that
  # potentially changes the structure of this editable list.
  _update: ->

    inputs = @_inputs()

    # if the last element is not blank, add one
    @get("controller").insertEmptyStudent() unless @get("controller").get("lastObject").name is ""
});