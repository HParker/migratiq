# frozen_string_literal: true
require 'spec_helper'

describe Migratiq::ArityChecker do
  class MultiArityClass
    def exactly_one(a)

    end

    def optional_one(a=nil)

    end

    def required_and_optional(a, b=nil)
    end
  end

  it 'will check arity for exact arguments' do
    method = MultiArityClass.new.method(:exactly_one)
    checker = Migratiq::ArityChecker.new(method)
    expect(checker.accepts?(1)).to be_truthy
    expect(checker.accepts?(2)).to be_falsey
    expect(checker.accepts?(-1)).to be_falsey
    expect(checker.accepts?(5)).to be_falsey
  end

  it 'will check arity for optional arguments' do
    method = MultiArityClass.new.method(:optional_one)
    checker = Migratiq::ArityChecker.new(method)
    expect(checker.accepts?(0)).to be_truthy
    expect(checker.accepts?(1)).to be_truthy
    expect(checker.accepts?(2)).to be_falsey
    expect(checker.accepts?(-1)).to be_falsey
    expect(checker.accepts?(5)).to be_falsey
  end
end
