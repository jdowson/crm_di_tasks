
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
        = render :partial => "outcome_fields", :locals => { :f => f }
- unless !@task.asset_id || @task.asset_type != "Opportunity"
  %tr
    %td{ :valign => :top, :colspan => 5 }
      %br
      - collapsed = true
      = subtitle :asset_status_information, collapsed, t(:asset_status, :scope => [:di, :tasks]) 
      .section
        %small#asset_status_intro{ hidden_if(!collapsed) }
          = t(:asset_status_intro, :scope => [:di, :tasks]) unless t(:asset_status_intro, :scope => [:di, :tasks]).blank?
        #asset_status_information{ hidden_if(collapsed) }
          = render :partial => "asset_status_fields", :locals => { :task => @task }
EOS


  # Install view hooks for models
  [ :task ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      sendd __FILE__, "Hook Start #{model}_top_section_bottom"
      Haml::Engine.new(HAML_TASK_FORM_EXT).render(view, :f => context[:f], :span => 5)
    end

  end
  
end
