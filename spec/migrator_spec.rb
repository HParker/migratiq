require 'spec_helper'

describe Migratiq do
  before(:each) {
    Sidekiq::Testing.disable!
    Sidekiq::ScheduledSet.new.clear
  }
  describe '.migrate' do
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
        MockWorker.migrate!
      }.to change(Sidekiq::ScheduledSet.new, :size).by(-2)
    end
  end
end
