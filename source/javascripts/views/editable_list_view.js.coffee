###
A view that allows a user to view and edit a list of items. This view will add and remove items based upon the user's use of the enter and delete keys.
###
ClassList.EditableListView = Ember.View.extend({

  tagName: "ul"
  classNames: [ "editable-list" ]
  templateName: "editable_list"

  # Indicates if the delete key is currently held down or not.
  deleteKeyDown: false

  # Indicates if an item has been deleeted since the delete key was pressed.
  itemDeleted: false

  # Indicates if an item has been added since the enter key was pressed.
  itemAdded: false

  # Bind to the keydown event and listen for the delete and return keys. If the user presses 
  # return, insert a new item. If the user presses delete and the current item is empty, delete it.
  keyDown: (event, params) ->

    keyCode = event.keyCode or event.which
    inputs = @_inputElements()
    index = @_currentIndex()

    # ignore the event unless an element is selected
    return unless index?

    # if the delete key is pressed down
    if (keyCode is 8 or keyCode is 46)

      # if the delete wasn't previously pressed down, the text field is empty and the element is not
      # the first element
      if not @deleteKeyDown and event.target.value == "" and index > 0

        @get("controller").removeAt(index)
        @_selectAt(index - 1)
        @itemDeleted = true

      # if the item has been deleted, prevent the delete key down event from propagating
      event.preventDefault() if @itemDeleted

      @deleteKeyDown = true

    # if the enter key is pressed down
    if keyCode is 13

      # add a item if a item has not already been added
      unless @itemAdded

        @get("controller").insertAt(index + 1, {})
        @itemAdded = true

        # select the new item after the insertion has propagated
        Ember.run.next(this, -> @_selectAt(index + 1))

      event.preventDefault()

  # Bind to the keyup event to determine when the user releases the key.
  keyUp: (event) ->

    keyCode = event.keyCode or event.which

    # reset the delete flags when the delete key is depressed
    if (keyCode is 8 or keyCode is 46)

      @itemDeleted = false
      @deleteKeyDown = false

    # reset the enter flags when the enter key is depressed
    @itemAdded = false if keyCode == 13

  # Retrieves the jQuery object representing the input elements in this editable list.
  _inputElements: -> @$().find("input")

  # Returns the index of the currently active element in this lis, or -1 if no elements are active.
  #
  # HACK: I couldn't find a better way to retrieve the current index using Ember. Ideally, Ember 
  # would pass along the model with the event data, and I could query the array. This method should
  # be removed when I find a better way to accomplish this.
  _currentIndex: -> @_inputElements().index(document.activeElement)

  # Selects the editable element at the provided index. If the index is out of bounds, this method 
  # does nothing.
  _selectAt: (index) ->

    inputs = @_inputElements()

    # ensure the index is in bounds
    return unless index >= 0 and index < inputs.length

    # select the element at the end
    inputs[index].selectionStart = inputs[index].value.length
    inputs[index].selectionEnd   = inputs[index].selectionStart
});