class Post < ActiveRecord::Base
  has_one :karnevalist
  belongs_to :sektion
  default_scope -> { order('created_at DESC') }
  validates :sektion_id, presence: true
  validates :content, presence: true

end
