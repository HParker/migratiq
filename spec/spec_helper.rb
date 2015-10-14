$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'migratiq'
require 'mock_worker'
require 'sidekiq/testing'
require 'pry'
