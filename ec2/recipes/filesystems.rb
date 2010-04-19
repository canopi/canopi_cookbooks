if node[:ebs_volumes]
  node[:ebs_volumes].each do |name, conf|
    if File.exists?(conf[:device])
      directory conf[:mount_point] do
        owner "root"
        group "root"
        mode "0755"
        not_if "test -d #{conf[:mount_point]}"
      end
      
      mount conf[:mount_point] do
        fstype conf[:type]
        device conf[:device]
      end
    else
      Chef::Log.info "Before mounting, you must attach volume #{name} to this instance #{node[:ec2][:instance_id]} at #{conf[:device]}"
    end
  end
end
