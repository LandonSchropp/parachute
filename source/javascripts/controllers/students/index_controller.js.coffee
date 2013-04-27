# The controller responsible for mutating the students list.
ClassList.StudentsIndexController = Ember.ArrayController.extend

  # Adds the student contained in student to this controller.
  add: ->

    # add the student to the students array
    @students.pushObject name: @get("student")

    # reset the student value
    @set('student', "")