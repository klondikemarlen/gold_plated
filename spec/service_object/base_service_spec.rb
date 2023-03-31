# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseService, type: :service do
  describe '.call - class method' do
    context 'when initializing' do
      before do
        allow_any_instance_of(described_class).to receive(:perform).and_return('peformed successfully')
      end

      it 'works when passed no arguments' do
        expect { described_class.call }.not_to raise_error
      end

      it 'works when passed arguments, but no options' do
        expect { described_class.call(:foo) }.not_to raise_error
      end

      it 'works when passed no arguments, but passed options' do
        expect { described_class.call(foo: :bar) }.not_to raise_error
      end

      it 'works when passed arguments, and options' do
        expect { described_class.call(:foo, foo: :bar) }.not_to raise_error
      end
    end

    context 'when successful' do
      before do
        allow_any_instance_of(described_class).to receive(:perform).and_return('peformed successfully')
      end

      it 'returns a success status' do
        expect(described_class.call).not_to be_errored
      end

      it 'returns the object itself from call method' do
        expect(described_class.call).to be_an_instance_of(described_class)
      end

      it 'has a result method of the correct type' do
        expect(described_class.call.result).to be_an_instance_of(described_class.result_class)
      end

      it 'supports return result by block' do
        described_class.call.success? do |result|
          expect(result).to be_an_instance_of(described_class.result_class)
        end
      end

      it 'when successful does not call failure block' do
        described_class.call.failure? do
          raise 'Should not be called'
        end
      end
    end

    context 'when errored' do
      before do
        allow_any_instance_of(described_class).to receive(:perform).and_raise(
          ArgumentError,
          'something went wrong',
        )
      end

      it 'returns the object itself from call method' do
        expect(described_class.call).to be_an_instance_of(described_class)
      end

      it 'has a result method of the correct type' do
        expect(described_class.call.result).to be_an_instance_of(described_class.result_class)
      end

      it 'supports return error by block' do
        described_class.call.failure? do |error|
          expect(error).to be_a_kind_of(ArgumentError).and have_attributes(
            message: 'something went wrong',
          )
        end
      end

      it 'when failed does not call success block' do
        described_class.call.success? do
          raise 'Should not be called'
        end
      end
    end
  end

  describe '#call - instance method' do
    before do
      @service = described_class.new
    end

    context 'when perform has not been defined in subclass' do
      it 'errors informatively' do
        expect { @service.call }.to raise_error(
          NotImplementedError,
          'must be implemented in a subclass as private method',
        )
      end
    end

    context 'when successful' do
      before do
        allow(@service).to receive(:perform).and_return('peformed successfully')
      end

      it 'returns a success status' do
        expect(@service.call).not_to be_errored
      end

      it 'returns the object itself from call method' do
        expect(@service.call).to be_an_instance_of(described_class)
      end

      it 'has a result method of the correct type' do
        expect(@service.call.result).to be_an_instance_of(described_class.result_class)
      end

      it 'supports return result by block' do
        @service.call.success? do |result|
          expect(result).to be_an_instance_of(described_class.result_class)
        end
      end

      it 'when successful does not call failure block' do
        @service.call.failure? do
          raise 'Should not be called'
        end
      end
    end

    context 'when errored' do
      before do
        allow(@service).to receive(:perform).and_raise(
          ArgumentError,
          'something went wrong',
        )
      end

      it 'returns the object itself from call method' do
        expect(@service.call).to be_an_instance_of(described_class)
      end

      it 'has a result method of the correct type' do
        expect(@service.call.result).to be_an_instance_of(described_class.result_class)
      end

      it 'supports return error by block' do
        @service.call.failure? do |error|
          expect(error).to be_a_kind_of(ArgumentError).and have_attributes(
            message: 'something went wrong',
          )
        end
      end

      it 'when failed does not call success block' do
        @service.call.success? do
          raise 'Should not be called'
        end
      end
    end
  end
end
