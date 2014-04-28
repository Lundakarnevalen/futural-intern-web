class TicketListing < ActiveRecord::Base

  validates :content, :presence => {:message => 'Du måste skriva något!' }
  validates :title, :presence => {:message => 'Du måste ange en Rubrik' }

  default_scope -> { order('created_at DESC') }
  belongs_to :user
  belongs_to :event



end
