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

      subject(:record) do
        klass.new({ root: { someValue: "testing" } })
      end

      it "allows access to fields using underscored accessors" do
        expect(record.some_value).to eql("testing")
      end
    end

    context "when passing in extra context data" do
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

      it do
        expect_any_instance_of(klass)
          .to receive(:validate!).with(other_data: "it works!")

        klass.new({ root: { someValue: "testing" } }, other_data: "it works!")
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

    context "when the extra fields are specified" do
      let(:klass) do
        Class.new do
          extend Scheemer::DSL

          schema do
            required(:item).hash do
              required(:content).hash do
                required(:name).filled(:string)
                optional(:address).filled(:string)
              end
            end
          end
        end
      end
      let(:data) do
        {
          item: {
            content: {
              name: "John",
              age: "9999",
              address: "John's Street 69"
            }
          }
        }
      end

      subject(:record) { klass.new(data) } 

      it "it allows all fields through" do
        expect(record.content.dig(:name)).to eql "John"
        expect(record.content.dig(:age)).to eql "9999"
        expect(record.content.dig(:address)).to eql "John's Street 69"
      end
    end
  end
end
