maintainer        "37signals"
maintainer_email  "sysadmins@37signals.com"
description       "Configures Sphinx, a high performance search engine"
version           "0.1"

%w{logrotate god}.each do |cookbook|
  depends cookbook
end

