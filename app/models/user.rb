class User < ApplicationRecord
  has_secure_password
  has_many :pastes
  validates_presence_of :username, :email, :password
  validates_uniqueness_of :username, :email
  validates :password, confirmation: { case_sensitive: true }

  # a superuser account with admin = false is not valid,
  # since superuser is a subset of admin
  validates_inclusion_of :admin, in: [true], if: :superuser?, message: 'must also be checked for a superuser account'
  def superuser?
    superuser
  end
end
