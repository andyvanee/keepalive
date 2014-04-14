class Site < ActiveRecord::Base
  validates_presence_of :url

  # required for clockwork database_tasks
  def at
    ping_at
  end

  # required for clockwork database_tasks
  def frequency
    interval || 1.year
  end

  # required for clockwork database_tasks
  def name
    "#{id}: #{url}"
  end

  def fetch
    require 'httparty'
    begin
      http = HTTParty.get(url)
      logger.info "#{url}: #{http.response.code}"
    rescue Exception => e
      logger.info "Error fetching: #{url} #{e}"
    end
  end
end
