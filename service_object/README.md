# Service Object

This is basically a super light, and less feature heavy version of https://github.com/apneadiving/waterfall
You should probably just use that library instead!

## Usage

```ruby
ExampleService.call(
  some_arg,
  some_option:,
).success? { |result|
  # do success thing
}.failure? do |error|
  # do failure thing
end
```

## Test Mocking

- [service_object_support.rb](/service_object/service_object_support.rb)
- [service_object_support_spec.rb](/spec/service_object/service_object_support_spec.rb)

```ruby
mock_successful_service = service_instance_double(
  ExampleService,
  result: {
    foo: :bar,
  },
)

allow(ExampleService).to receive(:call).with(
  some_arg,
).and_return(
  mock_successful_service,
)

# or
mock_failed_service = service_instance_double(
  ExampleService,
  error: 'some error',
)

allow(ExampleService).to receive(:call).with(
  some_arg,
).and_return(
  mock_failed_service,
)
```
