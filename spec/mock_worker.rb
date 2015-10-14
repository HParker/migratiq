require 'sidekiq'

class MockWorker
  include Sidekiq::Worker
  include Migratiq

  def perform(a, b, c = 1)
    puts "Doin work!"
  end
end
