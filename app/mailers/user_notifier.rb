class UserNotifier < ActionMailer::Base
  default :from => "\"#{SITE_NAME}\"<system@#{ROOT_URI}>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.authentication_notifier.user_activation.subject
  #
  def signup_greeting(user)
    @user = user
    mail :to => @user.email, :subject => "Welcome to Swapidy"
  end
  
  def honey_purchase(payment)
    @user = payment.user
    @payment = payment
    mail :to => @user.email, :subject => "Honey Purchase"
  end

  def free_honey_sent(free_honey)
    @free_honey = free_honey
    mail :to => @free_honey.receiver_email, :subject => "Free Honey"
  end
  
  def free_honey_completed(free_honey)
    @free_honey = free_honey
    mail :to => @free_honey.receiver_email, :subject => "Free Honey Received"
  end
  
  def free_honey_reward(free_honey)
    @free_honey = free_honey
    mail :to =>@free_honey.sender.email, :subject => "Free Honey Reward"
  end

end
