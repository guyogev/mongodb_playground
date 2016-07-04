class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  embeds_one :contact
  has_many :pets, as: :owner

  def self.create_user(fname, lname)
    # equivalnt to: `db.users.save({first_name: "aaa",last_name:"bbb"})`
    User.create!(first_name: fname, last_name: lname)
  end

  def self.where_first_name_is(fname)
    # equivalnt to: `db.users.find({first_name:"guy"})`
    User.where(first_name: fname).to_a
  end

  def self.where_last_name_like(lname)
    # equivalnt to: ` db.users.find({last_name: {$regex:lname}})`
    User.any_of(last_name: /#{lname}.*/).to_a
  end

  def self.update_fname(old_name, new_name)
    # db.users.update({"first_name":old_name}, {$set: {"first_name":new_name}})
    User.where(first_name: old_name).update_all(first_name: new_name)
  end

  def self.bulk_insert(users_arr)
    # equivalnt to:
    # ```
    #   bulk = db.users.initializeUnorderedBulkOp();
    #   users.forEach(function(x) { bulk.insert(x) });
    #   bulk.execute();
    # ```
    User.collection.insert(users_arr)
  end

  # one_to_on relation
  def self.set_contact(user, contact)
    # ```
    # u = db.users.find()[0]
    # c = db.contacts.find()[0]
    # u.contact_id = c._id
    # db.users.save(u)
    # ```
    user.contact = contact
    user.save
  end

  # has_many relation
  def self.add_pet(user, pet)
    user.pets.push pet
  end

  def self.user_pets(user)
    # ```
    # u = db.users.find()[0]
    # db.pets.find({owner_id: u._id})
    # ```
    user.pets
  end
end
