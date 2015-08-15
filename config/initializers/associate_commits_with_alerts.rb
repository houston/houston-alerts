Houston.observer.on "commit:create" do |commit|
  commit.associate_alerts_with_self
end unless Rails.env.test?
