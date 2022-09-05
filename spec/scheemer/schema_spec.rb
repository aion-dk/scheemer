require "spec_helper"

RSpec.describe Scheemer::Schema do
  describe ".validate!" do
    subject(:schema) do
      described_class.new do
        required(:test)
      end
    end

    context "with the required data" do
      it do
        expect { schema.validate!({ test: "something" }) }
          .to_not raise_error
      end
    end

    context "without the required data" do
      it do
        expect { schema.validate!({}) }
          .to raise_error(Scheemer::InvalidSchemaError)
      end
    end
  end
end
