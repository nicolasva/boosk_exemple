describe 'App.Zone', ->
  describe 'when instantiatied', ->
    beforeEach ->
      App.current_shop = 1

    it 'exhibits attributes', ->
      @zone = new App.Zone(name: 'Zone test')
      expect(@zone.get('name')).toBe('Zone test')

    it 'sets name to default', ->
      @zone = new App.Zone()
      expect(@zone.get('name')).toBe('')