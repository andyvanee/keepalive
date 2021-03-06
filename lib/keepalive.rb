require File.expand_path('../..', __FILE__)+"/config/boot.rb"

require 'clockwork'
require 'clockwork/manager_with_database_tasks'
module Clockwork
  Clockwork.manager = ManagerWithDatabaseTasks.new
  sync_database_tasks model: Site, every: 1.minute do |instance_job_name|
    id = instance_job_name.split(':').first
    begin
      task = Site.find(id)
      task.fetch
    rescue ActiveRecord::RecordNotFound => e
      # site has been deleted
    end
  end
end

Clockwork.run
