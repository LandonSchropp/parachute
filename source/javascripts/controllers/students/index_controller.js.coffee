# The controller responsible for mutating the students list.
ClassList.StudentsIndexController = Ember.ArrayController.extend
  
  # Returns the lists of groups of students. For example, if the students contained in this students
  # controller are:
  # 
  #     [ { name: "Bob" }, { name: "Lisa" }, { name: "Duke" }, { name: "Tyrone" } ]
  #
  # then the expected output of this function is:
  #
  # [
  #   [ [ { name: "Bob" }, { name: "Lisa" } ], [ { name: "Duke" }, { name: "Tyrone" } ] ],
  #   [ [ { name: "Bob" }, { name: "Tyrone" } ], [ { name: "Duke" }, { name: "Lisa" } ] ],
  #   [ [ { name: "Bob" }, { name: "Duke" } ], [ { name: "Lisa" }, { name: "Tyrone" } ] ]
  # ]
  groups: (->

    # remove all of the students whose names are empty or only whitespace
    students = @get("content").filter (student) -> student.name? and not /^\s*$/.test(student.name)

    # create a blank student
    blank_student = { name: "" }

    # get the results of the round robin algorithm
    roundRobinResults = @_roundRobin(students, blank_student)

  ).property("content.length")

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