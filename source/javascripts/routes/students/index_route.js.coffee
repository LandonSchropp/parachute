ClassList.StudentsIndexRoute = Ember.Route.extend

  setupController: (controller) ->

    # create an empty student and add it to the controller
    emptyStudent = { name: "" }
    controller.set("emptyStudent", emptyStudent)

    # set the initial content of the controller
    controller.set("content", [ Ember.copy(emptyStudent) ])