# frozen_string_literal: true

class ExampleService < BaseService
  initialize_result_class Struct.new(:foo)

  def initialize(arg1, kwarg1:)
    super
    @arg1 = arg1
    @kwarg1 = kwarg1
  end

  private

  def perform
    raise ArgumentError, 'cannot do xxx because of yyy' \
      if arg1.nil?

    do_thing
    do_other_thing
  end

  def do_thing
    # things
  end

  def do_other_thing
    result.foo = :bar
  end
end
