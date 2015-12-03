# frozen_string_literal: true
module Migratiq
  class ArityChecker
    def initialize(method_definition)
      @method_definition = method_definition
    end

    def accepts?(arg_count)
      allowed_range.include?(arg_count)
    end

    private

    attr_reader :method_definition

    def parameters
      method_definition.parameters
    end

    def required
      parameters.select { |param|
        param[0] == :req
      }.size
    end

    def optional
      parameters.select { |param|
        param[0] == :opt
      }.size
    end

    def allowed_range
      (required..required+optional)
    end

  end
end
