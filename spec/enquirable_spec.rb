# frozen_string_literal: true

require_relative '../enquirable'

describe 'Enquirable' do
  subject { Enquirable.new ['feature', 'Something', 'Third Thing'] }

  context 'calling some_method? on an enumerable' do
    it 'checks for that element' do
      expect(subject.feature?).to eql(true)
    end

    it 'converts upper to lower case' do
      expect(subject.something?).to eql(true)
    end

    it 'converts human readable to snake case' do
      expect(subject.third_thing?).to eql(true)
    end

    it 'returns false if element not found' do
      expect(subject.not_there?).to eql(false)
    end
  end

  context 'enumerable contains duplicates' do
    it 'raises an error for simple duplicates' do
      expect { Enquirable.new %w[dup dup] }.to(
        raise_error(ArgumentError, /duplicate/)
      )
    end

    it 'and raises an error for complex duplicates' do
      expect { Enquirable.new ['Complex Dup', 'complex_dup'] }.to(
        raise_error(ArgumentError, /duplicate/)
      )
    end
  end

  context 'calls super it' do
    it 'remains Enquirable' do
      expect(subject << 'feature99').to be_a_kind_of(Enquirable)
    end
  end
end

# if $PROGRAM_NAME == __FILE__
#   enq = Enquirable.new(['test', 'Something', 'Third Thing'])
#   raise unless enq.test? == true
#   raise unless enq.somthing? == true
#   raise unless enq.third_thing? == true
#   raise unless enq.not_here? == false
# end
