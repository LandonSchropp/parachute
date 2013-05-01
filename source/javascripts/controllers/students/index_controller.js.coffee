# The controller responsible for mutating the students list.
Parachute.StudentsIndexController = Ember.ArrayController.extend

  # An empty student, used to create other empty students.
  emptyStudent: null

  # The lists of pairs.
  listsOfPairs: []

  # Returns true if the lists of pairs is empty.
  listsOfPairsEmpty: (->
    @get("listsOfPairs").length is 0
  ).property("listsOfPairs")
  
  # Sets the lists of pairs of students. If the content of this controller is:
  # 
  #     [ { name: "Bob" }, { name: "Lisa" }, { name: "Duke" }, { name: "Tyrone" } ]
  #
  # then this method will set the lists of pairs to:
  #
  # [
  #   [ [ { name: "Bob" }, { name: "Lisa" } ], [ { name: "Duke" }, { name: "Tyrone" } ] ],
  #   [ [ { name: "Bob" }, { name: "Tyrone" } ], [ { name: "Duke" }, { name: "Lisa" } ] ],
  #   [ [ { name: "Bob" }, { name: "Duke" } ], [ { name: "Lisa" }, { name: "Tyrone" } ] ]
  # ]
  updateListsOfPairs: ->

    # create a deep copy of the filtered students so the students do not change when the students 
    # are updated
    students = Ember.copy(@_filteredStudents(), true)

    # get the results of the round robin algorithm
    listsOfPairs = @_roundRobin(students, @emptyStudent)

    # shuffle the lists for aesthetics (http://stackoverflow.com/a/6274398/262125)
    for list in listsOfPairs
      for pair, i in list

        j = Math.floor(Math.random() * (i + 1))
        temporaryPair = list[i]
        list[i] = list[j]
        list[j] = temporaryPair

    # ensure the empty item is always in the bottom right corner of the list
    for list in listsOfPairs
      for pair, i in list

        # ensure the extra item is always the second item in the pairs
        if pair[0] is @emptyStudent
          pair[0] = pair[1]
          pair[1] = @emptyStudent

        # swap the row with the last row if it contains the extra item (this works because only one
        # row should ever contain the extra item)
        if i isnt list.length - 1 and (pair[0] is @emptyStudent or pair[1] is @emptyStudent)
          
          temporaryPair = list[i]
          list[i] = list[list.length - 1]
          list[list.length - 1] = temporaryPair

    # HACK: This is a hack which allows the view to display the index of the list. Usually, the 
    # best way to accomplish this is to the use the `@index` property in the view. However, the 
    # handlebars sprockets gem compiles with an error `@index` is contained in the views. This is 
    # probably due to an old version of Handlebars being used to compile the templates. Ideally, I 
    # would fix the gem and submit a pull request on GitHub. However, given the scope of this 
    # project, it's easier to hack together a solution for now.
    for list, i in listsOfPairs
      list.index = i + 1

    # set the lists of pairs
    @set("listsOfPairs", listsOfPairs)

  # Returns an array of array of pairs of indices representing the result of the round robin
  # algorithm for the provided number of items to pair. If the provided items contains an odd nubmer
  # of elements, this algorithm adds the extra item to the result. The implementation for this 
  # algorithm was taken from: http://stackoverflow.com/questions/16207837.
  #
  # TODO: Move this into a separate object (single responsibility rule).
  _roundRobin: (items, extraItem) ->

    # base case
    return [] if items.length is 0

    # clone the items to the original items aren't changed
    items = Ember.copy(items)

    # add the extra item the number of items is odd
    items.push(extraItem) if items.length % 2 is 1

    # map the items to arrays of rotated items (fixing the pivot item)
    lists = [ 0..(items.length - 2) ].map (i) ->
      [ items[0] ].concat(items.slice(i + 1), items.slice(1, 1 + i))

    # fold the items on themselves to form pairs and return the result
    return lists.map (rotatedItems) ->
      [0..(rotatedItems.length / 2 - 1)].map (i) ->
        [ rotatedItems[i], rotatedItems[rotatedItems.length - i - 1] ]

    # return the lists
    return lists

  # Returns an array of students whose names are not empty or whitespace.
  _filteredStudents: -> 
    @get("content").filter (student) -> student.name? and not /^\s*$/.test(student.name)