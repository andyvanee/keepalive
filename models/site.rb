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

  # Working around issue by maintaining a list of last run times
  # https://github.com/tomykaira/clockwork/pull/88#issuecomment-40229343
  @@last_run ||= {}

  def fetch
    require 'httparty'
    if interval and @@last_run[id]
      if (Time.now - @@last_run[id]) < frequency
        return
      end
    end
    begin
      http = HTTParty.get(url)
      logger.info "#{url}: #{http.response.code}"
    rescue Exception => e
      logger.info "Error fetching: #{url} #{e}"
    end
    @@last_run[id] = Time.now
  end
end
