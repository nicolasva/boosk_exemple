# Use singleton class Preferences::Store.instance to access
#
# StoreInstance has a persistence flag that is on by default,
# but we disable database persistence in testing to speed up tests
#

require 'singleton'

module Preferences

  class StoreInstance
    attr_accessor :persistence

    def initialize
      @cache = Rails.cache
      @persistence = true
      load_preferences
    end

    def set(key, value, type)
      @cache.write(key, value)
      persist(key, value, type)
    end

    def exist?(key)
      @cache.exist? key
    end

    def get(key)
      @cache.read(key)
    end

    def delete(key)
      @cache.delete(key)
      destroy(key)
    end

    private

    def persist(cache_key, value, type)
      return unless should_persist?

      preference = Preference.find_or_initialize_by_key(cache_key)
      preference.value = value
      preference.value_type = type
      preference.save
    end

    def destroy(cache_key)
      return unless should_persist?

      preference = Preference.find_by_key(cache_key)
      preference.destroy if preference
    end

    def load_preferences
      return unless should_persist?

      Preference.valid.each do |p|
        @cache.write(p.key, p.value)
      end
    end

    def should_persist?
      @persistence and Preference.table_exists?
    end

  end

  class Store < StoreInstance
    include Singleton
  end

end