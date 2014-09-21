class Houston::Alerts::WorkerPresenter
  attr_reader :users
  
  def initialize(users)
    @users = users
  end
  
  def as_json(*args)
    users.pluck(:id, :first_name, :last_name)
         .map { |id, first, last| { id: id, name: "#{first} #{last}" } }
  end
  
end
