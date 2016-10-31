require 'spec_helper'

describe 'systemtap' do

  kernels = {
    '2.6.32-358.el6.x86_64' =>
    {
      :title    => 'title_64',
      :stap     => 'stap_64',
      :kernel   => '2.6.32-358.el6.x86_64',
    },
    '2.6.32-504.30.3.el6.x86_64' =>
    {
      :title    => 'title_66',
      :stap     => 'stap_66',
      :kernel   => '2.6.32-504.30.3.el6.x86_64',
    },
    '3.10.0-327.28.2.el7.x86_64' =>
    {
      :title    => 'title_72',
      :stap     => 'stap_72',
      :kernel   => '3.10.0-327.28.2.el7.x86_64',
    },
  }

  kernels.sort.each do |k,v|
    describe "on #{k}" do
      let(:facts) { {
        :kernelrelease => v[:kernel],
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

  describe 'not on supported kernel version' do
    let(:facts) { {
      :kernelrelease => '1.1.1'
    } }
    it { should contain_notify('systemtap: no modules available for kernel 1.1.1.')}
  end

end

