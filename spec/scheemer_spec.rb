# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer do
  it "has a version number" do
    expect(Scheemer::VERSION).not_to be_nil
  end

  describe "DSL" do
    context "with a defined schema" do
      let(:klass) do
        Class.new do
          extend Scheemer::DSL

          schema do
            required(:root).hash do
              required(:someValue).filled(:string)
            end
          end
        end
      end

      subject(:record) { klass.new({ root: { someValue: "testing" } }) }

      it "allows access to fields using underscored accessors" do
        expect(record.some_value).to eql("testing")
      end
    end

    context "without a defined schema" do
      let(:klass) do
        Class.new do
          extend Scheemer::DSL
        end
      end

      it { expect { klass.new({}) }.to raise_error(NotImplementedError) }
    end
  end
end
