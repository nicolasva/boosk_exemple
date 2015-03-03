describe 'Taxon model', ->
  beforeEach ->
    App.current_shop = 1
    @taxon = new App.Taxon(propertyTest: 'Test')

  afterEach ->

  describe 'when instantiated', ->
    it 'exhibits attributes', ->
      expect(@taxon.get('propertyTest')).toEqual('Test')

    it 'set name to default', ->
      expect(@taxon.get('name')).toEqual('')

    it 'sets URL to the collection URL', ->
      collection =
        url: '/collection'
      @taxon.collection = collection
      expect(@taxon.url()).toEqual('/collection')

  describe 'isLeaf', ->
    it 'returns true when right and left are consecutive', ->
      @taxon.set(rgt: 4, lft: 3)
      expect(@taxon.isLeaf()).toBeTruthy()

    it 'returns false when right and left are not consecutive', ->
      @taxon.set(rgt: 4, lft: 1)
      expect(@taxon.isLeaf()).toBeFalsy()

  describe 'isRoot', ->
    it 'returns true when parent_id is not set', ->
      @taxon.unset('parent_id')
      expect(@taxon.isRoot()).toBeTruthy()

    it 'returns false when parent_id is set', ->
      @taxon.set(parent_id: 1)
      expect(@taxon.isRoot()).toBeFalsy()

  describe 'left', ->
    it 'returns lft attribute', ->
      expect(@taxon.left()).toEqual(@taxon.get('lft'))

  describe 'right', ->
    it 'returns rgt attribute', ->
      expect(@taxon.right()).toEqual(@taxon.get('rgt'))

  describe 'children', ->
    it 'returns empty array when there is no collection', ->
      expect(@taxon.children()).toEqual([])

    it 'returns empty array when there is no id', ->
      @taxon.id = null
      expect(@taxon.children()).toEqual([])

    it 'returns others taxons with parent_id set to id', ->
      @taxon.set(id: 1)
      @collection = new Backbone.Collection
      @collection.add [
        new Backbone.Model(parent_id: 1)
        new Backbone.Model(parent_id: 2)
        new Backbone.Model(parent_id: 1)
        @taxon
      ]
      expect(@taxon.children().length).toEqual(2)

  describe 'level', ->
    it 'returns 0 when there is no collection', ->
      expect(@taxon.level()).toEqual(0)

    it 'returns ancestors count when there is a collection', ->
      @taxon.set(lft: 5, rgt: 8)
      @collection = new Backbone.Collection
      @collection.add [
        new App.Taxon(lft: 1, rgt: 10)
        new App.Taxon(lft: 2, rgt: 3)
        new App.Taxon(lft: 4, rgt: 9)
        new App.Taxon(lft: 6, rgt: 7)
        @taxon
      ]
      expect(@taxon.level()).toEqual(2)
