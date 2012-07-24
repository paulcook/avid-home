class TicketsController < ApplicationController
    before_filter :login_required
    
    
    def index
        @open_tickets = Ticket.find(:all,:conditions=>"status != 'closed' and status != 'resolved'",:order=>"updated_at desc")
        @closed_tickets = Ticket.find(:all,:conditions=>"status = 'closed' or status = 'resolved'",:order=>"updated_at desc")
        @tags = Ticket.tag_counts
    end
    
    def show
        @ticket = Ticket.find(params[:id])
    end
    
    def new
    
    end
    
    def create
        @ticket = Ticket.new
        @ticket.status = "new"
        @ticket.user_id = current_user.id
        
        ticket_type = params[:ticket][:ticket_type]
        title = params[:ticket][:title]
        body = params[:ticket][:body]
        tags = params[:ticket][:tag_list]
        
        @ticket.ticket_type = ticket_type
        @ticket.title = title
        @ticket.body = body
        @ticket.tag_list = tags
        
        if @ticket.save
            AdminNotifier.deliver_new_ticket(@ticket)
            flash[:notice] = "Ticket was successfully created."
            redirect_to dev_path
        else
            render :action=>:new
        end
    end
    
    def update
        @ticket = Ticket.find(params[:id])
        @ticket.status = params[:ticket][:status] if params[:ticket][:status]
        @ticket.ticket_type = params[:ticket][:ticket_type] if params[:ticket][:ticket_type]
        @ticket.title = params[:ticket][:title] if params[:ticket][:title]
        @ticket.body = params[:ticket][:body] if params[:ticket][:body]
        
        if @ticket.save
            flash[:notice] = "Ticket updated"
            redirect_to ticket_path(@ticket)
        else
            render :action=>:edit
        end
    end
    
    def tag
        @tickets = Ticket.find_tagged_with(params[:id])
        @tags = Ticket.tag_counts
    end
end
