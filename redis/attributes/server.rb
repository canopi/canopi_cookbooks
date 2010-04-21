set_unless[:redis][:datadir] = "/var/lib/redis"

if attribute?(:ec2)
  set_unless[:redis][:ec2_path] = "/mnt/redis"
end
