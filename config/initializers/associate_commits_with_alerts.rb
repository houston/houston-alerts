Houston.observer.on "commit:create" do |e|
  e.commit.associate_alerts_with_self
end unless Rails.env.test?
