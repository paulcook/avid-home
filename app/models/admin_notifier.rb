class AdminNotifier < ActionMailer::Base
  

  def new_ticket(ticket,sent_at = Time.now)
    subject    'AVID: New Ticket Submitted'
    recipients 'mandibal@avidmanager.com'
    from       'support@avidmanager.com'
    sent_on    sent_at
    
    body       :ticket => ticket
  end

end
