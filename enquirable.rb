# frozen_string_literal: true

<<~DOC
  # basic concept of an enumerable that supports queries on elements.

  e.g.

  enq = Enquireable['test', 'Something', 'Third Thing']

  enq.test?  => true
  enq.somthing?  => true
  enq.third_thing?  => true
  enq.not_here?  => false

  I need an inheritance tree:
  Object
  Array/Set/OtherEnumerable (passed in)
  TrueDelagtor -> delagator that converts back to caller
  EnquirableMeta?
  Enquirable?

  Specifics
  TrueDelagator - if delegating to Set from Enquriable
    converts all Set objects back into Enquirables before returning them.
DOC

require 'pry'

# An object that supports boolean flag queries for each element.
# e.g.
#   enq = Enquirable.new(['feature', 'Other Feature'])
#   enq.feature? == true
#   enq.other_feature == true
#   enq.non_pressent_feature == false
class Enquirable
  def initialize(enumerable)
    @enum = enumerable
    @mapping = build_mapping enumerable
  end

  def build_mapping(enum)
    mapping = {}
    enum.each do |element|
      sym = (element.gsub(' ', '_').downcase + '?').to_sym
      mapping_error(mapping, sym, element) if mapping.include? sym
      mapping[sym] = element
    end
    mapping.keys.to_set
  end

  def mapping_error(mapping, key, original)
    cause = mapping[key].inspect
    original = original.inspect
    key = key.inspect
    msg = "duplicate key #{key} produced by values: #{original} #{cause}"
    raise ArgumentError, msg
  end

  def respond_to_missing?(symbol, *)
    @enum.respond_to?(symbol) || super
  end

  def method_missing(symbol, *args, &block)
    return recast_enum(symbol, *args, &block) if @enum.respond_to? symbol

    return true if @mapping.include? symbol

    return false if symbol[-1] == '?'

    super
  end

  def recast_enum(symbol, *args, &block)
    enum = @enum.send(symbol, *args, &block)
    return Enquirable.new(enum) if enum.is_a? @enum.class

    enum
  end
end
