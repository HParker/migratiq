require "migratiq/version"
require "arity_checker"
require 'sidekiq/api'

module Migratiq
  def self.included(base)
    @classes ||= []
    @classes << base
    base.extend(ClassMethods)
  end

  module ClassMethods
    def migrate!
      method = self.new.method(:perform)
      checker = ArityChecker.new(method)
      outdated_jobs = Sidekiq::ScheduledSet.new.select { |job|
        !checker.accepts?(job['args'].size)
      }

      outdated_jobs.each do |job|
        next if Sidekiq::ScheduledSet.new.find_job(job['jid']).nil?
        Sidekiq::ScheduledSet.new.find_job(job['jid']).delete
      end
    end
  end
end
