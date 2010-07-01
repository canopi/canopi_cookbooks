#
# Cookbook Name:: ffmpeg
# Recipe:: default
#
# Copyright 2010, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"
include_recipe "subversion"

%w{checkinstall yasm texi2html libfaac-dev libfaad-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libx11-dev libxfixes-dev libxvidcore4-dev zlib1g-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "ffmpeg::x264"

unless `aptitude show ffmpeg` =~ /State: installed/
  git "FFmpeg Edge" do
    revision "3028fa75b761a0ebdcde5ab36d5468e7d049fae5"
    repository "git://git.ffmpeg.org/ffmpeg" 
    destination "/tmp/ffmpeg"
    action :sync
  end

  git "libswscale" do
    repository "git://git.ffmpeg.org/libswscale" 
    destination "/tmp/ffmpeg/libswscale"
    action :sync
  end
  
  execute "configure ffmpeg" do
    command "./configure  --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-pthreads --enable-libfaac --enable-libfaad --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libxvid --enable-x11grab"
    cwd "/tmp/ffmpeg"
  end

  execute "make ffmpeg" do
    command "make"
    cwd "/tmp/ffmpeg"
  end

  execute "install ffmpeg" do
    command "checkinstall --pkgname=ffmpeg --pkgversion '4:0.5+svn`date +%Y%m%d`' --backup=no --default"
    cwd "/tmp/ffmpeg"
  end
end
