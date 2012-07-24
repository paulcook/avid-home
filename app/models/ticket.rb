class Ticket < ActiveRecord::Base
    acts_as_commentable
    acts_as_taggable
    
    belongs_to :user
    
    validates_presence_of :ticket_type, :title, :body
    
end
