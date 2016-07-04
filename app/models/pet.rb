class Pet
  include Mongoid::Document

  field :name
  belongs_to :owner, polymorphic: true
end
