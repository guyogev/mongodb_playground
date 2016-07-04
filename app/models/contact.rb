class Contact
  include Mongoid::Document

  field :phone_number, type: String
  field :address, type: String
  belongs_to :user
end
