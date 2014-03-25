class Post < ActiveRecord::Base
  belongs_to :karnevalist
  belongs_to :sektion
  default_scope -> { order('created_at DESC') }
  validates :sektion_id, presence: true
  validates :karnevalist_id, presence: true
  validates :content, presence: true
  validates :title, presence: true

end
