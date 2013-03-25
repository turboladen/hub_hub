require 'spec_helper'


describe Spoke do
  fixtures :spokes

  describe '#initialize' do
    describe 'name' do
      it 'must not be empty' do
        expect(Spoke.new).to have(1).error_on(:name)
        expect(Spoke.new.errors_on(:name)).to include "can't be blank"
      end
    end
  end
end
