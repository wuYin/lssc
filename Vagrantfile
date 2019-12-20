Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
end
Vagrant.configure('2') do |outer_config|
  outer_config.vm.define "somemachine" do |config|
  config.vm.synced_folder("/Users/wuyin/shells/lssc", "/home/vagrant/lssc")
    config.vm.hostname = "ubuntu"
  end
end
