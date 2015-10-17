require "migratiq/version"
require "arity_checker"
require 'sidekiq/api'

module Migratiq
  def self.included(base)
    @classes ||= []
    @classes << base
    base.extend(ClassMethods)
  end

  def self.migrate_all!
    @classes.each do |klass|
      klass.migrate!
    end
  end

  module ClassMethods
    def migrate!(delete: false)
      method = self.new.method(:perform)
      checker = ArityChecker.new(method)
      outdated_jobs = check_arity(checker, Sidekiq::ScheduledSet.new)
      migrate_outdated(outdated_jobs, delete)
    end

    def migrate_by(arity:, &block)
      migraiton_plans[self.name][arity] = block
    end

    private

    def check_arity(checker, set)
      set.select { |job|
        !checker.accepts?(job['args'].size)
      }
      end

    def migrate_outdated(outdated, delete)
      outdated.each do |job|
        next if Sidekiq::ScheduledSet.new.find_job(job['jid']).nil?
        Sidekiq::ScheduledSet.new.find_job(job['jid']).delete if delete || plan_for(job['args'].size)
        if plan_for(job['args'].size)
          new_args = plan_for(job['args'].size).call(job['args'])
          self.perform_in(5, *new_args)
        end
      end
    end

    def migraiton_plans
      @migration_plans ||= Hash.new({})
    end

    def plan_for(arity)
      if migraiton_plans[self.name] && migraiton_plans[self.name][arity]
        migraiton_plans[self.name][arity]
      end
    end
  end
end
