# frozen_string_literal: true
class MockMigratorWorker
  include Sidekiq::Worker
  include Migratiq



  def perform(a, b, c = 1)
    puts "Doin work!"
  end


  migrate_by(arity: 5) do |a, b, c, d, e|
    [b, a]
  end
end
