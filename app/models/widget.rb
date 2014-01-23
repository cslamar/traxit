class Widget
  include Mongoid::Document

  field :simple_name, type: String
  field :description, type: String
  field :purchase, type: Hash
  field :properties, type: Hash
  field :location, type: String

  embeds_many :services

  validates :simple_name, presence: true
  validates :description, presence: true
  validates :purchase, presence: true

end
