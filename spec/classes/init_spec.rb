require 'spec_helper'
describe 'easy_sysctl' do
  context 'with default values for all parameters' do
    it { should contain_class('easy_sysctl') }
  end
end
