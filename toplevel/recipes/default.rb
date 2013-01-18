
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


ruby_block "compile TOPLEVEL" do
  block do
    IO.popen( <<-EOH
       cd /vagrant/Platform
       scons
     EOH
   ) { |f|  f.each_line { |line| puts line } }
  end
#  creates "/vagrant/somethign to run?"
end
