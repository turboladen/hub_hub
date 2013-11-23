# http://emberjs.com/guides/models/using-the-store/

class HubHub.Store extends DS.Store
  # Override the default adapter with the `DS.ActiveModelAdapter` which
  # is built to work nicely with the ActiveModel::Serializers gem.
  adapter: '_ams'

