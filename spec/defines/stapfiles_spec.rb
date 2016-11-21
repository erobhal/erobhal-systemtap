require 'spec_helper'

describe 'systemtap::stapfiles' do

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
      let(:title) { v[:title] }
      let(:params) {{
        :stap => v[:stap],
      } }

      context "default params on #{k}" do
        it {
            should contain_file("/root/systemtap/#{v[:stap]}.ko").with({
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'source'  => "puppet:///modules/systemtap/#{v[:stap]}.ko",
            'require' => 'File[/root/systemtap]',
          })
        }
        it {
            should contain_exec("load-stapfile-#{v[:title]}").with({
            'command' => "/usr/bin/staprun -L /root/systemtap/#{v[:stap]}.ko",
            'unless'  => "/bin/grep -q #{v[:stap]} /proc/modules",
            'require' => ['Package[systemtap-runtime]', "File[/root/systemtap/#{v[:stap]}.ko]"],
          })
        }
        it { should compile.with_all_deps }
      end

      context "ensure set to absent on #{k}" do
      let(:params) { {
        :stap   => v[:stap],
        :ensure => 'absent',
      } }

        it {
            should contain_file("/root/systemtap/#{v[:stap]}.ko").with({
            'ensure'  => 'absent',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'source'  => "puppet:///modules/systemtap/#{v[:stap]}.ko",
            'require' => 'File[/root/systemtap]',
          })
        }
        it {
            should contain_exec("load-stapfile-#{v[:title]}").with({
            'command' => "/usr/bin/staprun -d #{v[:stap]}",
            'onlyif'  => "/bin/grep -q #{v[:stap]} /proc/modules",
            'require' => 'Package[systemtap-runtime]',
          })
        }
        it { should compile.with_all_deps }
      end
      context "ensure set to unvalid value on #{k}" do
      let(:params) { {
        :stap   => v[:stap],
        :ensure => 'yes',
      } }
        it 'should fail' do
          expect {
            should contain_class('systemtap')
          }.to raise_error(Puppet::Error,/must be 'present' or 'absent'. Detected value is 'yes'./)
        end
      end
    end
  end
end
