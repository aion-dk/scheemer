require "spec_helper"

require "ostruct"

RSpec.describe Scheemer::Params do
  describe ".validate!" do
    context "when schema validation fails" do
      let(:klass) do
        Class.new(described_class) do
          def self.schema
            ->(_) { OpenStruct.new(failure?: true) }
          end
        end
      end

      it do
        expect { klass.validate!({}) }
          .to raise_error(InvalidSchemaError)
      end
    end
  end

  describe ".new" do
    context "with a defined set structure" do
      let(:klass) do
        Class.new(described_class) do
          def self.schema
            ::Dry::Schema.Params do
              required(:root).hash do
                required(:someValue).filled(:string)
              end
            end
          end
        end
      end

      subject(:record) { klass.new({ root: { someValue: "testing" } }) }

      it "allows access to fields using underscored accessors" do
        expect(record.some_value).to eql("testing")
      end
    end
  end
end
