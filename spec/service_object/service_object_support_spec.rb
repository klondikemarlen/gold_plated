# frozen_string_literal: true

require 'rails_helper'

describe ServiceSupport, type: :support do
  describe '#instance_double_support' do
    context 'when passing a result object' do
      before do
        @mock_service = service_instance_double(
          ExampleService,
          result: {
            foo: :bar,
          },
        )
      end

      it 'builds an object that responds to success?, and has the correct result data' do
        @mock_service.success? do |result|
          expect(result.foo).to eq :bar
        end
      end

      it 'builds an object that responds to failure?, but does not yield anything' do
        @mock_service.failure? do
          raise 'should not be called'
        end
      end

      it 'returns self as result of success? method' do
        expect(@mock_service.success? { 'whatever' }).to eq(@mock_service)
      end

      it 'returns self as result of failure? method' do
        expect(@mock_service.failure? { 'whatever' }).to eq(@mock_service)
      end
    end

    context 'when passing an error object' do
      before do
        @mock_service = service_instance_double(
          ExampleService,
          error: 'some error object',
        )
      end

      it 'builds an object that responds to failure?, and has the correct error object' do
        @mock_service.failure? do |error|
          expect(error).to eq 'some error object'
        end
      end

      it 'builds an object that responds to success?, but does not yield anything' do
        @mock_service.success? do
          raise 'should not be called'
        end
      end

      it 'returns self as result of success? method' do
        expect(@mock_service.success? { 'whatever' }).to eq(@mock_service)
      end

      it 'returns self as result of failure? method' do
        expect(@mock_service.failure? { 'whatever' }).to eq(@mock_service)
      end
    end

    context 'when passed an invalid result object' do
      it 'raises a mocking error' do
        expect {
          service_instance_double(
            ExampleService,
            result: {
              not_a_valid_result_attribute: 'whatever',
            },
          )
        }.to raise_error(
          RSpec::Mocks::MockExpectationError,
          /class does not implement the instance method: not_a_valid_result_attribute/,
        )
      end
    end

    context 'when passed neither a result nor an error' do
      it 'fails informatively' do
        expect {
          service_instance_double(ExampleService)
        }.to raise_error(
          ArgumentError,
          /must supply a result or an error/,
        )
      end
    end

    context 'when passed both a result and an error' do
      it 'fails informatively' do
        expect {
          service_instance_double(
            ExampleService,
            result: 'anything',
            error: 'anything',
          )
        }.to raise_error(
          ArgumentError,
          /only supply a result or an error/,
        )
      end
    end

    context 'when result is not splattable' do
      it 'fails informatively' do
        expect {
          service_instance_double(
            ExampleService,
            result: 'non-spatable-thing',
          )
        }.to raise_error(
          ArgumentError,
          /result must respond to :to_h/,
        )
      end
    end
  end
end
