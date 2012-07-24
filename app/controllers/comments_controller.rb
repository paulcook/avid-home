class CommentsController < ApplicationController
    before_filter :login_required
    before_filter :setup_objects
    
    def create
        comment_data = {:title=>params[:comment][:title],:comment=>params[:comment][:comment],:user_id=>current_user.id}
        @obj.comments << Comment.new(comment_data)
        redirect_to @return_to
    end
    
    def destroy
        comment = Comment.find(params[:id])
        @obj.comments.delete(comment)
        redirect_to @return_to
    end
    
protected
    def setup_objects
        if params[:ticket_id]
            @obj = Ticket.find(params[:ticket_id])
            @return_to = ticket_path(@obj)
        end
    end
    
end
