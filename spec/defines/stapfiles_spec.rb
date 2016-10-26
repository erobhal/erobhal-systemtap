require 'spec_helper'

describe 'systemtap::stapfiles' do

  platforms = {
    'RedHat 6.4' =>
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.4',
      :stapfile => 'stap_64',
    },
    'RedHat 6.6' =>
    {
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.6',
      :stapfile => 'stap_66',
    },
  }


  platforms.sort.each do |k,v|
    describe "on #{k}" do
      let(:facts) { {
        :osfamily => v[:osfamily],
        :operatingsystemrelease => v[:operatingsystemrelease],
      } }
      let(:title) { v[:stapfile] }

      context "default params on #{k}" do
        it {
            should contain_file("/root/systemtap/#{v[:stapfile]}.ko").with({
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0600',
            'source'  => "puppet:///modules/systemtap/#{v[:stapfile]}.ko",
            'require' => 'File[/root/systemtap]',
          })
        }
        it {
            should contain_exec("load-stapfile-#{v[:stapfile]}").with({
            'command' => "/usr/bin/staprun -L /root/systemtap/#{v[:stapfile]}.ko",
            'unless'  => "/bin/grep -q #{v[:stapfile]} /proc/modules",
            'require' => ['Package[systemtap-runtime]', "File[/root/systemtap/#{v[:stapfile]}.ko]"],
          })
        }
        it { should compile.with_all_deps }
      end
    end
  end
end
