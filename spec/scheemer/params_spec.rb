# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer::Params do
  describe ".new" do
    context "with a defined set structure" do
      let(:klass) do
        Class.new do
          include Scheemer::Params
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
end
