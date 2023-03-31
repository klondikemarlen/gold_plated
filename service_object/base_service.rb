# frozen_string_literal: true

class BaseService
  attr_reader :error

  def self.result_class
    @result_class ||= Struct.new('Result')
  end

  def self.initialize_result_class(result_class)
    @result_class = result_class
  end

  ##
  # safe class level call that always returns an instance
  def self.call(*args, **options)
    instance = new(*args, **options)
    instance.call
    instance
  end

  def initialize(*_args, **_options)
    # permits class level call on children with arbitrary arguments
  end

  def call
    perform
    self
  rescue StandardError => e
    self.error = e
    self
  end

  def result
    @result ||= self.class.result_class.new
  end

  def success?
    yield result unless errored?

    self
  end

  def failure?
    yield error if errored?

    self
  end

  def errored?
    !error.nil?
  end

  private

  attr_writer :error

  def perform
    raise NotImplementedError, 'must be implemented in a subclass as private method'
  end
end
