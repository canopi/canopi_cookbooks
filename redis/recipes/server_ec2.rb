if (node[:ec2] && `mount|grep #{node[:redis][:ec2_path]}`.chomp.empty?)

  service "redis" do
    action :stop
  end

  if ! FileTest.directory?(node[:redis][:ec2_path])
    execute "install-redis" do
      command "mv #{node[:redis][:datadir]} #{node[:redis][:ec2_path]}"
      not_if do FileTest.directory?(node[:redis][:ec2_path]) end
    end

    directory node[:redis][:ec2_path] do
      owner "redis"
      group "redis"
    end
  end
  
  directory node[:redis][:datadir] do
    owner "redis"
    group "redis"
  end

  mount node[:redis][:datadir] do
    device node[:redis][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :mount
  end

  service "redis" do
    action :start
  end
end
