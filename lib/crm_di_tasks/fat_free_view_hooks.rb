
class DITasksFFViewHooks < FatFreeCRM::Callback::Base

  # Some HAML fragments
  
  # New fields for task object
  HAML_TASK_FORM_EXT = <<EOS
%tr
  %td{ :valign => :top, :colspan => 5 }
    .label 
      = I18n.t(:description, :scope => [:di, :tasks]) << ":"
    = f.text_area :description, { :rows => 4, :style => "width:496px;" }
%tr
  %td{ :valign => :top, :colspan => 5 }
    %br
    - collapsed = @task.completed_at.nil?
    = subtitle :outcome_information, collapsed, t(:outcome, :scope => [:di, :tasks]) 
    .section
      %small#outcome_information_intro{ hidden_if(!collapsed) }
        = t(:outcome_intro, :scope => [:di, :tasks]) unless t(:outcome_intro, :scope => [:di, :tasks]).blank?
      #outcome_information{ hidden_if(collapsed) }
        %table{ :width => 476, :cellpadding => 0, :cellspacing => 0 }
          %tr
            %td{ :valign => :top }
              .label 
                = I18n.t(:outcome_type, :scope => [:di, :tasks]) << ":" 
              = f.lookup_select :outcome_type_id, { :lookup_name => "task.category.outcometype", :parent => :category, :parent_key_type => :code, :include_blank_if_empty => true }, { }, { :style => "width:160px" }
            %td= spacer
            %td{ :valign => :top }
              #stype
                .label 
                  = I18n.t(:outcome_sub_type, :scope => [:di, :tasks]) << ":"
                = f.lookup_select :outcome_sub_type_id, { :lookup_name => "task.category.outcometype.subtype", :parent => :outcome_type_id, :hide_element_if_empty => "stype", :include_blank_if_empty => true }, { }, { :style => "width:308px" }
          %tr
            %td{ :valign => :top, :colspan => 3 }
              .label 
                = I18n.t(:outcome_text, :scope => [:di, :tasks]) << ":"
              = f.text_area :outcome_text, { :rows => 2, :style => "width:472px;" }
EOS


  # Install view hooks for models
  [ :task ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      sendd __FILE__, "Hook Start #{model}_top_section_bottom"
      Haml::Engine.new(HAML_TASK_FORM_EXT).render(view, :f => context[:f], :span => 5)
    end

  end
  
end
