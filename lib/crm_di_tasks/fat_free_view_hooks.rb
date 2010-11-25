
class DITasksFFViewHooks < FatFreeCRM::Callback::Base

  # Some HAML fragments
  
  # New fields for task object
  HAML_TASK_FORM_EXT = <<EOS
%tr
  %td{ :valign => :top }
    .label 
      = I18n.t(:outcome_type, :scope => [:di, :tasks]) << ":" 
    = f.lookup_select :outcome_type_id, { :lookup_name => "task.category.outcometype", :parent => :category, :parent_key_type => :code, :include_blank_if_empty => true }, { }, { :style => "width:160px" }
  %td= spacer
  %td{ :colspan => 3, :valign => :top }
    #stype
      .label 
        = I18n.t(:outcome_sub_type, :scope => [:di, :tasks]) << ":"
      = f.lookup_select :outcome_sub_type_id, { :lookup_name => "task.category.outcometype.subtype", :parent => :outcome_type_id, :hide_element_if_empty => "stype", :include_blank_if_empty => true }, { }, { :style => "width:320px" }
EOS

  HAML_TASK_SIDEBAR_EXT = <<EOS
= task_side_bar_item(t(:type,     :scope => [:di, :tasks]), model.blah_type_id)
= task_side_bar_item(t(:sub_type, :scope => [:di, :tasks]), model.blah_sub_type_id)
EOS

# lookup_select_tag :ucontact_type_id, { :lookup_name => "contact.type", :option_key_type => :code, :include_blank_if_empty => "[No Types Created]", :include_blank => "Select Type" }, @contact.contact_type_id, { :style => "width:240px" }
# lookup_select_tag :ucontact_sub_type_id, { :lookup_name => "contact.type.subtype", :parent_id => @contact.contact_type_id, :include_blank_if_empty => "NO STYPES", :parent_control => :ucontact_type_id, :parent_key_type => :code, :hide_element_if_empty => "stype2", :disable_if_empty => true }, @contact.contact_sub_type_id, { :style => "width:240px" }

  # Install view hooks for models
  [ :task ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      sendd __FILE__, "Hook Start #{model}_top_section_bottom"
      Haml::Engine.new(HAML_TASK_FORM_EXT).render(view, :f => context[:f], :span => 5)
    end

  #  define_method :"show_#{model}_sidebar_bottom" do |view, context|
  #    sendd __FILE__, "Hook Start show_#{model}_sidebar_bottom"
  #    Haml::Engine.new(HAML_TASK_SIDEBAR_EXT).render(view, :model => context[model])
  #  end

  end
  
end
