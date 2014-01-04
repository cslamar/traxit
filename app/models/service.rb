class Service
  include Mongoid::Document

  field :start, type: Date
  field :finish, type: Date
  field :short_description, type: String
  field :long_description, type: String
  field :completed, type: Boolean, default: false

  embedded_in :widget
end
