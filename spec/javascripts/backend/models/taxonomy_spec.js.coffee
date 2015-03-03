describe 'Taxonomy model', ->
  describe 'when instantiated', ->
    beforeEach ->
      App.current_shop = 1
      @collection = new Backbone.Collection()
      @taxonsCollectionStub = sinon.stub(App.Collections, 'Taxons').returns(@collection)
      @taxonomy = new App.Taxonomy(propertyTest: 'Test')

    afterEach ->
      @taxonsCollectionStub.restore()

    it 'exhibits attributes', ->
      expect(@taxonomy.get('propertyTest')).toEqual('Test')

    it 'set name to default', ->
      expect(@taxonomy.get('name')).toEqual('')

    it 'create a new taxons collection', ->
      expect(@taxonsCollectionStub).toHaveBeenCalledOnce()

    it 'sets taxons collection URL', ->
      expect(@collection.url).toEqual('/shops/' + App.current_shop + '/taxonomies/' + @taxonomy.id + '/taxons')

    it 'sets the taxonomy URL to the collection URL', ->
      collection =
        url: '/collection'
      @taxonomy.collection = collection
      expect(@taxonomy.url()).toEqual('/collection')
