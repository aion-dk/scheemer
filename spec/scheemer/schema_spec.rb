# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer::Schema do
  describe ".validate!" do
    subject(:schema) do
      described_class.new do
        required(:test).filled(:string)
      end
    end

    context "with the required data" do
      it do
        expect { schema.validate!({ test: "something" }) }
          .not_to raise_error
      end
    end

    context "without the required data" do
      it do
        expect { schema.validate!({}) }
          .to raise_error(Scheemer::InvalidSchemaError)
      end
    end
  end

  describe "#json_schema" do
    context "when a key is using unsupported `format?`" do
      subject(:schema) do
        described_class.new do
          required(:test).filled(:str?, format?: /asd/)
        end
      end

      it "generates the schema without it" do
        expect(schema.json_schema).to eql(
          {
            "$schema": "http://json-schema.org/draft-06/schema#",
            properties: {
              test: {
                minLength: 1,
                type: "string",
              },
            },
            required: ["test"],
            type: "object",
          }
        )
      end
    end
  end
end
