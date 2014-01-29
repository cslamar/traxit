class Handler
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String

  embedded_in :widget

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    return "#{first_name} #{last_name}"
  end

  def check_name(fname, lname)
    if fname == first_name && lname == last_name
      return true
    else
      return false
    end
  end

end
