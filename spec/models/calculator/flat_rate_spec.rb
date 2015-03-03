require 'spec_helper'

describe Calculator::FlatRate do
  let(:calculator) { Calculator::FlatRate.new(preferred_amount: 10) }
  let(:order) { mock_model Order }

  specify { calculator.compute.should == 10 }
  specify { calculator.compute(order).should == 10 }
end