# frozen_string_literal: true

module ServiceObjectSupport
  def service_instance_double(doubled_class, result: nil, error: nil)
    raise ArgumentError, 'must supply a result or an error' \
      if result.nil? && error.nil?
    raise ArgumentError, 'only supply a result or an error' \
      if !error.nil? && !result.nil?
    raise ArgumentError, 'result must respond to :to_h' \
      if !result.nil? && !result.respond_to?(:to_h)

    if error.nil?
      mock_result = instance_double(doubled_class.result_class, **result)
      mock_service = instance_double(doubled_class, result: mock_result)

      allow(mock_service).to receive(:success?) do |&block|
        block.call(mock_result)

        mock_service
      end

      allow(mock_service).to receive(:failure?) do |&_block|
        mock_service
      end
    else
      mock_service = instance_double(doubled_class, error:)
      allow(mock_service).to receive(:success?) do |&_block|
        mock_service
      end

      allow(mock_service).to receive(:failure?) do |&block|
        block.call(error)

        mock_service
      end
    end

    mock_service
  end
end

RSpec.configure do |config|
  config.include ServiceObjectSupport
end
