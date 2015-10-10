class Houston::Alerts::ProjectPresenter
  attr_reader :projects

  def initialize(projects)
    @projects = projects
  end

  def as_json(*args)
    projects.pluck(:id, :name).map { |id, name| { id: id, name: name } }
  end

end
