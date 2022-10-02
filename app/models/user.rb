class User < ApplicationRecord

  validates :user_id, presence: true, uniqueness: true, on: [:create, :update]
  validates :password, presence: true, on: [:create, :update]

  validates_length_of :user_id, minimum: 5, maximum: 20
  validates_length_of :password, minimum: 5, maximum: 20
  validates_length_of :nickname, minimum: 0, maximum: 30
  validates_length_of :comments, minimum: 0, maximum: 100

  def nickname
    self[:nickname] || self.user_id
  end

  private

  def get_error
    return "Undefined Error" if self.errors.empty?
    error_key = self.errors.messages.keys.first
    first_error = self.errors.messages[error_key]
    "#{first_error.keys[0]}: #{first_error.values[0]}"
  end
end