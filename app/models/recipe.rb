class Recipe < ApplicationRecord
  validates :title, :making_time, :serves, :ingredients, :cost, presence: true
end
