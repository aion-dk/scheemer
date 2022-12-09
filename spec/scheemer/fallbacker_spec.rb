# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer::Fallbacker do
  context "with a deep level key" do
    subject(:data) do
      described_class.apply(
        { someValue: "testing" },
        { "content.fall.back" => "my-value" }
      )
    end

    it "should place the pair" do
      expect(data.dig(:content, :fall, :back)).to eql("my-value")
      expect(data.dig(:someValue)).to eql("testing")
    end
  end

  context "when key exists" do
    subject(:data) do
      described_class.apply(
        { content: { key: "old-key" } },
        { "content.key" => "new-key" }
      )
    end

    it "shouldn't replace the existing value" do
      expect(data.dig(:content,  :key)).to eql("old-key")
    end
  end
end
