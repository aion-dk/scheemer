# frozen_string_literal: true

require "spec_helper"

RSpec.describe Scheemer::Extensions::CaseModifier do
  using described_class

  it { expect(:"".camelcase).to eql :"" }
  it { expect(:asd.camelcase).to be :asd }
  it { expect(:Asd.camelcase).to be :Asd }
  it { expect(:asd_qwe.camelcase).to be :asdQwe }
  it { expect(:asd_qwe_zxc.camelcase).to be :asdQweZxc }
end
