ClassList.StudentsIndexRoute = Ember.Route.extend

  setupController: (controller) ->

    # set the initial content of the controller
    controller.set("content", [ 
      { name: "Bob" },
      { name: "Lisa" },
      { name: "Ted" },
      { name: "Tyrone" }
    ])