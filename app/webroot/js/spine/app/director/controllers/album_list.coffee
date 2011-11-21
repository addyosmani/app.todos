Spine ?= require("spine")
$      = Spine.$

class AlbumList extends Spine.Controller
  
  elements:
    '.optCreate'              : 'btnCreate'

  events:
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    'click .optCreate'        : 'create'
    
  selectFirst: true
    
  constructor: ->
    super
    Spine.bind('album:exposeSelection', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    console.log 'AlbumList::change'
    @renderBackgrounds items if items.length
    
#    selected = Album.find(list[0]) if Album.exists(list[0])
#    Album.current(selected) if selected and !selected.destroyed
#    Spine.trigger('change:selectedAlbum', selected)
  
  select: (item) ->
    @exposeSelection()
    Album.current(item) if item and !item.destroyed
    Spine.trigger('change:selectedAlbum', item)
    
  exposeSelection: ->
    list = Gallery.selectionList()
    @children().removeClass("active")
    for id in list
      if Album.exists(id)
        item = Album.find(id) 
        @children().forItem(item).addClass("active")
        
    Spine.trigger('expose:sublistSelection', Gallery.record) if Gallery.record
  
  render: (items, newAlbum) ->
    console.log 'AlbumList::render'
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></div>'
      else
        @html '<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button></div>'
    
    @change items
    @el
  
  renderBackgrounds: (albums) ->
    for album in albums
      album.uri
        width: 50
        height: 50
        , (xhr, album) =>
          @callback(xhr, album)
        , 3
  
  callback: (json, item) =>
    el = @children().forItem(item)
    searchJSON = (itm) ->
      res = for key, value of itm
        value
    css = for itm in json
      o = searchJSON itm
      'url(' + o[0].src + ')'
    el.css('backgroundImage', css)
  
  children: (sel) ->
    @el.children(sel)

  create: ->
    Spine.trigger('create:album')

  click: (e) ->
    console.log 'AlbumList::click'
    item = $(e.target).item()
    
    # open Album panel if any panel is open
#    if App.hmanager.hasActive()
#      @openPanel('album', App.showView.btnAlbum)
    
    item.addRemoveSelection(Gallery, @isCtrlClick(e))
    @select item
    App.showView.trigger('change:toolbar', 'Album')
    
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    #@openPanel('album', App.showView.btnAlbum)
    item = $(e.currentTarget).item()
    @change item
    Spine.trigger('show:photos', item)
    
    e.stopPropagation()
    e.preventDefault()
    false
  
  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item

module?.exports = AlbumList