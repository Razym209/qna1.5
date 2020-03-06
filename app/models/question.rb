class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy, as: :rewardable
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
