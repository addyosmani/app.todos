class App extends Spine.Controller
  
  elements:
    '#sidebar'    : 'sidebarEl'
    '#contacts'   : 'contactsEl'
    '#editor'     : 'editorEl'
    '#album'      : 'albumEl'
    '#upload'     : 'uploadEl'
    '#grid'       : 'gridEl'
    '.vdraggable' : 'vDrag'
    '.hdraggable' : 'hDrag'

  constructor: ->
    super
    @sidebar = new Sidebar
      el: @sidebarEl
    @contacts = new Contacts
      el: @contactsEl
    @editor = new Editor
      el: @editorEl
    @album = new Album
      el: @albumEl
    @upload = new Upload
      el: @uploadEl
    @grid = new Grid
      el: @gridEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.initDrag @vDrag,
      initSize: @proxy ->
        $(@sidebar.el).width()/2
      disabled: false
      axis: 'x'
      min: 250
      max: @proxy ->
        $(@el).width()/2

    @hmanager = new Spine.Manager(@editor, @album, @upload, @album, @grid)
    @hmanager.initDrag @hDrag,
      initSize: @proxy ->
        $(@contacts.el).height()/2
      disabled: true
      axis: 'y'
      min: 0
      max: @proxy ->
        (@contacts.el).height()/2

    Contact.fetch()

$ ->
  window.App = new App(el: $('body'))