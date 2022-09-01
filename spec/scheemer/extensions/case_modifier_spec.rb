require "spec_helper"

RSpec.describe Scheemer::Extensions::CaseModifier do
  using Scheemer::Extensions::CaseModifier

  it { expect(:"".camelcase).to eql :"" }
  it { expect(:"asd".camelcase).to eql :"asd" }
  it { expect(:"Asd".camelcase).to eql :"Asd" }
  it { expect(:"asd_qwe".camelcase).to eql :"asdQwe" }
  it { expect(:"asd_qwe_zxc".camelcase).to eql :"asdQweZxc" }
end
