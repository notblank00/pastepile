class Paste < ApplicationRecord
  before_save :set_default_values
  belongs_to :user, optional: true
  validates_presence_of :content
  validates_inclusion_of :private, in: [false], if: :anonymous?, message: 'pastes can only be created once logged in'

  def set_default_values
    self.language = 'plaintext' if language.blank?
    self.name = 'Untitled' if name.blank?
  end

  def anonymous?
    users_id.blank?
  end
end
