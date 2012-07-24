module TicketsHelper

    def ticket_status_options
        [["Open","open"],["In Development","in_development"],["Resolved","resolved"],["Closed","closed"]]
    end
    
    def ticket_type_options
        [["Bug","bug"],["Feature","feature"]]
    end
end
