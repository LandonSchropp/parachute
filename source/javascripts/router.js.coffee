ClassList.Router.map ->
  @resource "students", path: "/", ->
    @route 'index', path: '/'
  