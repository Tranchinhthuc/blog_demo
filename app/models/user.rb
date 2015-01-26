class User < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  # User co nhieu quan he following(thuoc loai active_ralationship) voi source cua no la followed_id
  # Luu y la 2 dong dau da dat quan he giua user va ralationship roi!
  has_many :active_relationships, class_name: "Relationship", 
                                   foreign_key: "follower_id", 
                                   dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # attr_accessor la 1 phuong thuc, co tac dung la cac hash cua no khong can phai dinh nghia trong CT
  # O duoi, co su dung remember_token, activation_token, reset_token ma truoc do ko can dinh nghia
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
    validates :password, length: { minimum: 6 }, allow_blank: true


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  #Gan cho bien digest gia tri bang voi gia tri digest can xac nhan(password_digest, rememner_diggest hoac reset_digest)
  #Ma hoa chuoi digest nhan dc, kiem tra xem co trung voi gia tri token tuong ung trong session ko
  #Co thi tra lai true, nguoc lai la false
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  # Ham dc goi trong truong hop dang xuat
  # Chuyen gia tri remember_digest ve nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  # Tao mot reset_digest(thuc ra la tao 1 token roi gan gia tri cho digest bang voi token) --> luu no vao CSDL
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
        following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Entry.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)

  end
  
 # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end