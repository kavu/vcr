require 'spec_helper'

describe VCR::Config do
  describe '#cassette_library_dir=' do
    temp_dir(File.expand_path(File.dirname(__FILE__) + '/fixtures/config_spec'))

    it 'creates the directory if it does not exist' do
      expect { VCR::Config.cassette_library_dir = @temp_dir }.to change { File.exist?(@temp_dir) }.from(false).to(true)
    end

    it 'does not raise an error if given nil' do
      expect { VCR::Config.cassette_library_dir = nil }.to_not raise_error
    end
  end

  describe '#default_cassette_options' do
    it 'has a hash with some defaults even if it is set to nil' do
      VCR::Config.default_cassette_options = nil
      VCR::Config.default_cassette_options.should == { :match_requests_on => VCR::RequestMatcher::DEFAULT_MATCH_ATTRIBUTES }
    end

    it "returns #{VCR::RequestMatcher::DEFAULT_MATCH_ATTRIBUTES.inspect} for :match_requests_on when other defaults have been set" do
      VCR::Config.default_cassette_options = { :record => :none }
      VCR::Config.default_cassette_options.should == {
        :record            => :none,
        :match_requests_on => VCR::RequestMatcher::DEFAULT_MATCH_ATTRIBUTES
      }
    end
  end

  describe '.stub_with' do
    it 'stores the given symbols in http_stubbing_libraries' do
      VCR::Config.stub_with :fakeweb, :typhoeus
      VCR::Config.http_stubbing_libraries.should == [:fakeweb, :typhoeus]
    end
  end

  describe '#ignore_localhost' do
    it 'sets VCR.http_stubbing_adapter.ignore_localhost?' do
      [true, false].each do |val|
        VCR.http_stubbing_adapter.ignore_localhost = !val
        expect {
          VCR::Config.ignore_localhost = val
        }.to change { VCR.http_stubbing_adapter.ignore_localhost? }.from(!val).to(val)
      end
    end

    it 'stores the value even when VCR.http_stubbing_adapter is nil' do
      VCR.stub!(:http_stubbing_adapter).and_return(nil)
      [true, false].each do |val|
        VCR::Config.ignore_localhost = val
        VCR::Config.ignore_localhost?.should == val
      end
    end
  end
end
