class Paste < ApplicationRecord
  validates_presence_of :private
  validates_presence_of :content
end
