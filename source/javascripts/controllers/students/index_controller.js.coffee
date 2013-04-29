# The controller responsible for mutating the students list.
ClassList.StudentsIndexController = Ember.ArrayController.extend

  # An empty student, used to create other empty students.
  emptyStudent: null

  # The lists of groups.
  groups: []

  # Returns true if the groups array is empty.
  groupsEmpty: (->
    @get("groups").length is 0
  ).property("groups")
  
  # Sets the lists of groups of students. For example, if the students contained in this controller
  # are:
  # 
  #     [ { name: "Bob" }, { name: "Lisa" }, { name: "Duke" }, { name: "Tyrone" } ]
  #
  # then this function will set groups to:
  #
  # [
  #   [ [ { name: "Bob" }, { name: "Lisa" } ], [ { name: "Duke" }, { name: "Tyrone" } ] ],
  #   [ [ { name: "Bob" }, { name: "Tyrone" } ], [ { name: "Duke" }, { name: "Lisa" } ] ],
  #   [ [ { name: "Bob" }, { name: "Duke" } ], [ { name: "Lisa" }, { name: "Tyrone" } ] ]
  # ]
  updateGroups: ->

    # create a deep copy of the filtered students so the students do not change when the students 
    # are updated
    students = Ember.copy(@_filteredStudents(), true)

    # get the results of the round robin algorithm
    results = @_roundRobin(students, Ember.copy(@emptyStudent))

    # HACK: This is a hack which allows the view to display the index of the list. Usually, the 
    # best way to accomplish this is to the use the `@index` property in the view. However, the 
    # handlebars sprockets gem compiles with an error `@index` is contained in the views. This is 
    # probably due to an old version of Handlebars being used to compile the templates. Ideally, I 
    # would fix the gem and submit a pull request on GitHub. However, given the scope of this 
    # project, it's easier to hack together a solution for now.
    for list, i in results
      list.index = i + 1

    # the the groups to the results of the round robin algorithm using the filtered students array
    @set("groups", results)

  # Returns an array of array of pairs of indices representing the result of the round robin
  # algorithm for the provided number of items to pair. If the provided items contains an odd nubmer
  # of elements, this algorithm adds the extra item to the result. The implementation for this 
  # algorithm was taken from: http://stackoverflow.com/questions/16207837.
  #
  # TODO: Move this into a separate object (single responsibility rule).
  _roundRobin: (items, extra_item) ->

    # base case
    return [] if items.length is 0

    # clone the items to the original items aren't changed
    items = Ember.copy(items)

    # add the extra item the number of items is odd
    items.push(extra_item) if items.length % 2 is 1

    # map the items to arrays of rotated items (fixing the pivot item)
    items = [ 0..(items.length - 2) ].map (i) ->
      [ items[0] ].concat(items.slice(i + 1), items.slice(1, 1 + i))

    # fold the items on themselves to form pairs and return the result
    return items.map (rotatedItems) ->
      [0..(rotatedItems.length / 2 - 1)].map (i) ->
        [ rotatedItems[i], rotatedItems[rotatedItems.length - i - 1] ]

  # Returns an array of students whose names are not empty or whitespace.
  _filteredStudents: -> 
    @get("content").filter (student) -> student.name? and not /^\s*$/.test(student.name)