# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include AvidHelpers
  include TagsHelper
  
  def url_for_dynasty(dynasty,season=nil)
    if season
      "http://#{APP_CONFIG['ncaa_url']}/#{dynasty.to_param}/seasons/#{season.to_param}"
    else
      "http://#{APP_CONFIG['ncaa_url']}/dynasties/#{dynasty.to_param}"
    end
  end
  
  # parse and return data as HTML
  def to_html(rawtext)
    return "" if rawtext.nil?
    
    r = RedCloth.new h(rawtext)
    r.to_html    
  end
end
