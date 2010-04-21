include_recipe "git"

unless `aptitude show x264` =~ /State: installed/
  git "/tmp/x264" do
    repository "git://git.videolan.org/x264.git"
    action :sync
  end

  execute "configure x264" do
    command "./configure"
    cwd "/tmp/x264"
  end

  execute "make x264" do
    command "make"
    cwd "/tmp/x264"
  end

  execute "install x264" do
    command "checkinstall --pkgname=x264 --pkgversion '1:0.svn`date +%Y%m%d`+`git rev-list HEAD -n 1 | head -c 7`' --backup=no --default"
    cwd "/tmp/x264"
  end
end
