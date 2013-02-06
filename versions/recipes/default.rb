#this chef scrpt is intended to pin LOCAL versions of specific resources where they are critical for
#this specific package.

#if the version of a package is not important, then it need not be listed here, 

#apt versions can be pinned e.g.
#apt_preference "mercurial" do
#   pin "version 2.2.2-1"
#   pin_priority "1001"
#end

#pining gcc to gcc-4.4
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
