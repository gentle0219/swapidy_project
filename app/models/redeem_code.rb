class RedeemCode < ActiveRecord::Base
  attr_accessible :code, :user_id, :expired_date, :honey_amount, :email
  
  attr_accessor :email
  
  belongs_to :user
  
  STATUES = {:pending => 0, :completed => 1, :cancelled => 2}
  scope :pending, :conditions => {:status => STATUES[:pending]}
  
  validates :honey_amount, :status, :expired_date, :code, :presence => true
  validates_uniqueness_of :code
  #validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}#, :message => "Invalid email address"
  
  before_validation :generate_fields
  
  def expired?
    Time.now > self.expired_date
  end
  
  def redeemable?
    errors.add(:email, "could not be blank") if email.nil? || email.blank?
    return false unless errors.empty?
    
    return false unless self.status == STATUES[:pending] && !expired?
    if user.nil? && User.where(:email => self.email).exists?
      errors.add(:email, "has signed up before")
      return false
    end
    return true
  end
  
  def redeem
    self.user = User.signup_user(:email => receiver_email)
    self.status = STATUES[:completed] 
    self.save
    self.receiver.update_attribute(:honey_balance, (self.receiver.honey_balance || 0.00) + self.receiver_honey_amount)
    
    receiver_notification = Notification.new(:title => "Free #{self.honey_amount} Honey Received")
    receiver_notification.user = self.user
    receiver_notification.description = "Free #{self.receiver_honey_amount} Honey receipted"
    receiver_notification.save
    UserNotifier.redeem_completed(self).deliver
  end
  
  private

    def default_expired_days
      SwapidySetting.get('REDEEM-DEFAULT_EXPIRED_DAYS') rescue 7
    end
    def default_honey
      SwapidySetting.get('REDEEM-DEFAULT_HONEY') rescue 50.00
    end
  
    def generate_fields
      while(self.code.nil? || self.code.blank? || RedeemCode.where(:code => self.code).exists? ) do
        number_charset = %w{1 2 3 4 6 7 9}
        string_charset = %w{A C D E F G H J K M N P Q R T V W X Y Z}
        number_code = (1..4).map{ number_charset.to_a[rand(number_charset.size)] }.join("")
        char_code = (1..2).map{ string_charset.to_a[rand(string_charset.size)] }.join("")
        self.code = "SWEETHONEY#{number_code}#{char_code}"
      end
      self.status = STATUES[:pending] unless self.status
      self.expired_date = (DateTime.now + default_expired_days.days) unless self.expired_date
      self.honey_amount = default_honey if self.honey_amount.nil? || self.honey_amount == 0.0
    end

end
