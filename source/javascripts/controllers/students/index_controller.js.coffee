# The controller responsible for mutating the students list.
ClassList.StudentsIndexController = Ember.ArrayController.extend
  
  # Returns the lists of pairs of students. For example, if the students contained in this students
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

    # remove all of the empty or blank elements
    students = $.grep @get("content"), (student) -> student.name? and not /^\s*$/.test(student.name)

    # add an empty student the the number of students is null
    students.push({ name: "" }) unless students.length % 2 is 0

    # handle the base cases
    return [] if students.length is 0
    return [ [ students[0], null ] ] if students.length is 1

    # determine the number of lists and the list length
    numberOfLists = students.length - 1
    listLength = students.length / 2

    # the array that contains the resulting lists
    lists = [ ]

    # iterate through each of the lists
    for i in [ 0..(numberOfLists - 1) ]

      collection = [ 0..(listLength - 1) ]

      func = (index) -> 
        [ students[index], students[students.length - 1 - index] ]

      mapping = $.map([ 0..(listLength - 1) ], (index) -> 
        [ students[index], students[students.length - 1 - index] ]
      )

      # determine the pairings for the current list
      pairs = $.map [ 0..(listLength - 1) ], (index) -> 

        # BUG FIX: Unfortunately, jQuery automatically flattens the inner array, so it's necessary 
        # to double wrap it. I'm not using the browser's map function because I want cross-browser
        # compatibility.
        [ [ students[index], students[students.length - 1 - index] ] ]

      # reverse and duplicate each pair in the list
      pairs = $.map pairs, (pair) -> [ pair, [ pair[1], pair[0] ] ]

      # remove the pairs beginning with a blank student from the list
      unless students.lenght % 2 is 0
        pairs = $.grep pairs, (pair) -> pair[0].name

      # sort the pairs list
      pairs = pairs.sort (first, second) ->
        return -1 if first[0].name.toLowerCase() < second[0].name.toLowerCase()
        return  1 if first[0].name.toLowerCase() > second[0].name.toLowerCase()
        return 0;

      lists.push(pairs)

      # remove the fixed student from the array
      fixedStudent = students.pop()

      # rotate the students
      rotatedStudent = students.shift()
      students.push(rotatedStudent)

      # add the fixed student back into the array
      students.push(fixedStudent)

    # return the lists
    lists

  ).property("content.length")