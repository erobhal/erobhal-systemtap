require 'spec_helper'

describe 'systemtap' do

  platforms = {
    'RedHat 6.4' =>
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.4',
      :title    => 'title_64',
      :stap     => 'stap_64',
    },
    'RedHat 6.6' =>
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.6',
      :title    => 'title_66',
      :stap     => 'stap_66',
    },
  }


  platforms.sort.each do |k,v|
    describe "on #{k}" do
      let(:facts) { {
        :osfamily => v[:osfamily],
        :operatingsystemrelease => v[:operatingsystemrelease],
      } }

      context "default params on #{k}" do
        it {
            should contain_package('systemtap-runtime').with({
            'ensure' => 'present',
          })
        }
        it {
            should contain_file('/root/systemtap').with({
            'ensure' => 'directory',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
          })
        }
        it { should compile.with_all_deps }
      end
    end
  end

  describe 'not on supported OS platform' do
    let(:facts) { {
      :osfamily => 'WrongOS',
      :operatingsystemrelease => '6.6'
    } }
    it 'should fail' do
      expect {
        should contain_class('systemtap')
      }.to raise_error(Puppet::Error,/systemtap supports osfamilies RedHat. Detected osfamily is WrongOS./)
    end
  end

  describe 'not on supported OS version' do
    let(:facts) { {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '77.7'
    } }
    it { should contain_notify('systemtap supports RedHat 6.4 and 6.6. Detected RedHat release is 77.7.')}
  end


end

