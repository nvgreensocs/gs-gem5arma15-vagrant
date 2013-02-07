
#  -------    TOPLEVEL  --------

# LICENSETEXT
# 
#   Copyright (C) 2012 : GreenSocs Ltd
#       http://www.greensocs.com/ , email: info@greensocs.com
# 
# The contents of this file are subject to the licensing terms specified
# in the file LICENSE. Please consult this file for restrictions and
# limitations that may apply.
# 
# ENDLICENSETEXT

#remember to put these in your versions script
#package "libboost-program-options1.49-dev"
#package "libboost-regex1.49-dev"
#package "libboost-system1.49-dev"
#package "libboost-filesystem1.49-dev"

ruby_block "compile TOPLEVEL" do
  block do
    IO.popen(  <<-EOH
       for i in #{node[:prefix]}/bash.profile.d/*; do . $i; done
       cd /vagrant/Platform
       scons
     EOH
   ) { |f|  f.each_line { |line| puts line } }
  end
#  creates "/vagrant/somethign to run?"
end
