# frozen_string_literal: true
require 'spec_helper'

describe Migratiq do
  before(:each) {
    Sidekiq::Testing.disable!
    Sidekiq::ScheduledSet.new.clear
  }
  describe '.migrate!' do
    it 'will not delete jobs with expected arity' do
      MockWorker.perform_in(1, 'a', 'b', 'c')
      MockWorker.perform_in(1, 'a', 'b')
      expect {
        MockWorker.migrate!
      }.to change(Sidekiq::ScheduledSet.new, :size).by(0)
    end

    it 'will delete scheduled jobs with unexpected arity' do
      MockWorker.perform_in(1, 'a', 'b', 'c', 'too many')
      MockWorker.perform_in(1, 'too few')
      expect {
        MockWorker.migrate!(delete: true)
      }.to change(Sidekiq::ScheduledSet.new, :size).by(-2)
    end

    it 'will not delete jobs if you do not ask it to' do
      MockWorker.perform_in(1, 'a', 'b', 'c')
      MockWorker.perform_in(1, 'a', 'b', 'c', 'too many')
      expect {
        MockWorker.migrate!
      }.to change(Sidekiq::ScheduledSet.new, :size).by(0)
    end

  end

  describe '.migrate_by' do
    it 'will transform the params with migrate_by if available' do
      MockMigratorWorker.perform_in(1, 'a', 'b', 'c', 'too many', 'matched arity migraiton plan')
      MockMigratorWorker.perform_in(1, 'a', 'b', 'c', 'no migration plan')
      expect {
        MockMigratorWorker.migrate!
      }.to change(Sidekiq::ScheduledSet.new, :size).by(0)

      expect(Sidekiq::ScheduledSet.new.to_a.last['args']).to eq(['b', 'a'])
    end

    it 'can transform the params with migrate_by and delete extras' do
      MockMigratorWorker.perform_in(1, 'a', 'b', 'c', 'too many', 'matched arity migraiton plan')
      MockMigratorWorker.perform_in(1, 'a', 'b', 'c', 'no migration plan')
      expect {
        MockMigratorWorker.migrate!(delete: true)
      }.to change(Sidekiq::ScheduledSet.new, :size).by(-1)

      expect(Sidekiq::ScheduledSet.new.to_a.last['args']).to eq(['b', 'a'])
    end
  end

  describe '.migrate_all!' do
    it 'migrates all classes that include migratiq' do
      expect(MockWorker).to receive(:migrate!)
      expect(MockMigratorWorker).to receive(:migrate!)
      Migratiq.migrate_all!
    end
  end
end
