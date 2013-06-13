require File.expand_path('../support/helpers', __FILE__)

describe 'equallogic::default' do

  include Helpers::Equallogic

  # Example spec tests can be found at http://git.io/Fahwsw
  it 'should download the ISO to the /deploy folder' do
    directory("/deploy").must_have(
      :mode, "755"
    ).with(
      :owner, "root"
    ).and(
      :group, "root"
    )
    file("/deploy/equallogic-host-tools.iso").must_exist
  end

  # Not going to try to verify the signing key import. Seems more
  # trouble than it is worth as the package install will fail and 
  # the install test case will fail.

  it 'should create the /mnt/iso folder' do
    # Not going to check user/group.  Because the iso is mounted, it
    # complains about an unknown user
    directory("/mnt/iso").must_have(
      :mode, "755"
    )
  end

  # Did everything install?
  it 'should install equallogic from the ISO' do
    package("equallogic-host-tools").must_be_installed
    package("kmod-dm-switch").must_be_installed
  end

  # Shouldn't error if iscsiadm has been wrapped
  it 'should be able to run eqltune without errors' do
    result = assert_sh("eqltune --version")
    assert result
  end

  # Ensure that the gro tune files are present
  it 'should create the eqltune.d directory' do
    directory("/etc/equallogic/eqltune.d").must_have(
      :mode, "755"
    ).with(
      :owner, "root"
    ).and(
      :group, "root"
    )
  end

  it 'should create the GRO off files' do
    node['equallogic']['ifaces'].each do |iface|
      file("/etc/equallogic/eqltune.d/gro.#{iface}").must_exist
    end
  end

  it "Enables and starts the iscsid daemon" do
    service("iscsid").must_be_running
    service("iscsid").must_be_enabled
  end

  it "Enables and starts the ehcmd daemon" do
    service("ehcmd").must_be_running
    service("ehcmd").must_be_enabled
  end

  # I'm not testing lvm.conf but should be

  # Make sure we are removing non-mpio interfaces
  it 'should not include any interfaces that are absent from the iface list' do
    result = assert_sh("rswcli -L --eo | grep '33.33.33'")
    assert result
  end

  # Check to see if we have any critical performance issues
  # There is currently one warning that I cannot figure out how to address and even if
  # I can, I think that it will require an actual connection to the management interface of 
  # the EQL to solve. (so no tests will be done)

  # it 'should not have any critical eqtune performance issues' do
  #   result = assert_sh("eqltune -q")
  #   assert result
  # end
end
