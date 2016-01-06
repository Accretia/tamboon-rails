class App
  def all_charities
    Charity.order(:created_at).all
  end

  def build_charity(attributes = {})
    # NOTE currency is for now fixed to THB.
    Charity.new(attributes.merge(total: 0, currency: "THB"))
  end

  def create_charity(attributes)
    charity = build_charity(attributes)
    charity.save
    charity
  end

  def update_charity(id,attributes)
    #p(attributes)
    Charity.update(id,attributes )

  end
  def count_charities
    Charity.count
  end

  def find_charity(id)
    Charity.find_by(id: id)
  end

  def all_users
      User.order(:email).all
  end

  def build_user(attributes = {})
    # NOTE currency is for now fixed to THB.
    User.new(attributes.merge(total: 0, currency: "THB"))
  end

  def create_user(attributes)
      user = build_user(attributes)
      user.save
      user
  end

  def find_user(id)
    User.find_by(id:id)
  end
end
