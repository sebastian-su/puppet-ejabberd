require 'spec_helper_acceptance'

describe 'ejabberd class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'ejabberd': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('ejabberd') do
      it { should be_installed }
    end

    describe service('ejabberd') do
      it { should be_enabled }
      it { should be_running }

      describe port(5222) do
        it { is_expected.to be_listening }
      end

    end

    describe user('ejabberd') do
       it { should exist }
    end

    describe file('/etc/ejabberd/ejabberd.cfg') do
      it { should contain 'localhost' }
    end
  end
end
