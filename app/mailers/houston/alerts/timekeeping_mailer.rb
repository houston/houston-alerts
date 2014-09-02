class Houston::Alerts::TimekeepingMailer < ViewMailer
  helper "houston/alerts/alert"
  
  def self.deliver_to!(email_addresses, alerts, options={})
    alerts = alerts.includes(:project).closed
    User.with_email_address(email_addresses).map do |user|
      prompt_user_for_time_spent_on(user, alerts.unestimated_by(user), options={}).deliver!
    end
  end
  
  def prompt_user_for_time_spent_on(user, alerts, options={})
    @user = user
    @alerts = alerts
    
    @options = {
      "5m"  => 0.1,
      "30m" => 0.5,
      "1h"  => 1,
      "2h"  => 2,
      "4h"  => 4,
      "1d"  => 8,
      "2d"  => 16,
      "4d"  => 32
    }
    
    if @user.respond_to?(:reset_authentication_token!)
      @user.reset_authentication_token! 
      @auth_token = @user.authentication_token
    end
    
    mail({
      to:       user,
      subject:  "Did you spend time on these alerts?",
      template: "houston/alerts/timekeeping"
    })
  end
  
end
