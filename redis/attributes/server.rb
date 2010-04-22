set_unless[:redis][:datadir]      = "/var/lib/redis"
set_unless[:redis][:bind_address] = ipaddress

if attribute?(:ec2)
  set_unless[:redis][:ec2_path] = "/mnt/redis"
end
