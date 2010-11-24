
# crm_di_tasks
# init.rb
# Plugin initialization point
#
# Keep to a minimum in here due to rails EVAL'ing rather than require'ing this file.
# Delegate most functionality to main initializer.

require "fat_free_crm"

# Plugin Registration
FatFreeCRM::Plugin.register(:crm_di_tasks, initializer) do

          name "Fat Free Delta Indigo Tasks module"
       authors "Delta Indigo"
       version "0.1"
   description "Adds Delta Indigo tasks enhancements to Fat Free CRM"
  dependencies :crm_di_core

end
  
# delegate the rest to lib/crm_di_contacts.rb
require File.join(File.dirname(__FILE__), "lib", "crm_di_tasks")
