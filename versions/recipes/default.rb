
#  -------    VERSIONS  --------

# LICENSETEXT
# 
#   Copyright (C) 2013 : GreenSocs Ltd
#       http://www.greensocs.com/ , email: info@greensocs.com
# 
# The contents of this file are subject to the licensing terms specified
# in the file LICENSE. Please consult this file for restrictions and
# limitations that may apply.
# 
# ENDLICENSETEXT


# List of all the required packages, and below 'alternatives' is used to set the right versions of critical packages

# If we are not running as root, with a /vagrant, then assume the user will set up their own environment
if ENV['USER']=='root' && File.exists?("/vagrant")

bash "Update package list" do
code <<-EOH
    apt-get update
EOH
end

package "gcc-4.4"
package "g++-4.4"
package "gcc-4.7"
package "g++-4.7"
package "build-essential"


package "mercurial"
package "git"
package "scons"
package "libc-dev"
package "make"
package "python-dev"
package "swig"
package "m4"
package "liblua5.2-dev" 
package "libgoogle-perftools-dev"
package "libxerces-c-dev"

package "cmake"
package "libboost-filesystem1.49-dev"

package "libboost-program-options1.49-dev"
package "libboost-regex1.49-dev"
package "libboost-system1.49-dev"

package "corkscrew"
package "libprotobuf-dev"
package "protobuf-compiler"
package "libgoogle-perftools-dev"

bash "Set up gcc alternatives" do
code <<-EOH
   update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 10
   update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 20

   update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.7 10
   update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 20

   update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
   update-alternatives --set cc /usr/bin/gcc

   update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
   update-alternatives --set c++ /usr/bin/g++


    update-alternatives --config gcc
    update-alternatives --config g++


    update-alternatives --set gcc "/usr/bin/gcc-4.4"
    update-alternatives --set g++ "/usr/bin/g++-4.4"
EOH
end
else puts "WARNING: Assuming the user has set up all the needed packages and versions"
end

bash "Set up source versions" do
code <<-EOH
   mkdir -p "#{node[:prefix]}/bash.profile.d"
   echo "export version_gem5_systemc_armmodel=4423607d090d0c60d1d9cda86ffa2bfe50a34ad6" >  "#{node[:prefix]}/bash.profile.d/version_gem5-systemc-armmodel.profile"
   echo "export version_aceslave=60b1aed9908837e8991109d056894adcb7dcb892" >  "#{node[:prefix]}/bash.profile.d/version_aceslave.profile"
   echo "export version_greenlib=9882235a024597fc3183a1db9eeb43be47f45532" >  "#{node[:prefix]}/bash.profile.d/version_greenlib.profile"
   echo "export version_gem5=9562" >  "#{node[:prefix]}/bash.profile.d/version_gem5.profile"
EOH
end
