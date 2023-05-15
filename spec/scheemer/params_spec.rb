# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer::Params do
  describe ".new" do
    context "with a defined set structure" do
      let(:klass) do
        Class.new do
          extend Scheemer::Params::DSL
        end
      end

      subject(:record) { klass.new({ someValue: "testing" }) }

      it "allows access to fields using underscored accessors" do
        expect(record.some_value).to eql("testing")
      end

      it "allows access to fields using camelcase accessors" do
        expect(record.someValue).to eql("testing")
      end
    end
  end

  describe ".on_missing" do
    context "with a shallow key" do
      let(:klass) do
        Class.new do
          extend Scheemer::Params::DSL

          on_missing path: "content", fallback_to: { fall: "back" }
        end
      end

      subject(:record) { klass.new({ someValue: "testing" }) }

      it "fills in the missing missing" do
        expect(record.content).to eql({ fall: "back" })
        expect(record.someValue).to eql("testing")
      end
    end
  end
end
