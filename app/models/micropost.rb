class Micropost < ActiveRecord::Base
      belongs_to :user
      default_scope order: 'microposts.created_at DESC'
  attr_accessible :content
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
