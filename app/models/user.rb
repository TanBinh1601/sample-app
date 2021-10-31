class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  validates :name, presence: true,
    length: {minimum: Settings.validate.length.min_2}

  validates :email, presence: true,
    length: {maximum: Settings.validate.length.max_200},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password
end