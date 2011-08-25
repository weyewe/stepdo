class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  
  has_many :posts
  
  after_create :add_uuid
  
  def add_uuid
    self.uuid = UUIDTools::UUID.timestamp_create.to_s
    self.save
  end
  
  
  
end
