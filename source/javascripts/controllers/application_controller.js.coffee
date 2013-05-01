Parachute.StudentsController = Ember.ArrayController.extend

  # Adds the student contained in student to this controller.
  add: ->

    # add the student to the students array
    @pushObject name: @get("student")

    # reset the student value
    @set('student', "")