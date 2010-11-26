
class DITasksFFControllerHooks < FatFreeCRM::Callback::Base

  # attaching to: ApplicationController:before_filter "hook(:app_before_filter, self)"
  define_method :"app_before_filter" do |controller, context|

    # Trapping the 'complete' action for tasks
    # ----------------------------------------
    # Called with:
    #   controller.action_name     => 'complete'
    #   controller.controller_name => 'tasks'
    #   controller.params (e.g.)   => {"bucket"=>"due_next_week", "_method"=>"put", "_"=>"", "controller"=>"tasks", "action"=>"complete", "id"=>"179"}
    #
    # Render confirmation/outcome info. modal box if this has not already been done
    if (controller.controller_name == 'tasks')
      
      if (controller.action_name == 'complete')
        controller.send :render, :complete_confirm_show unless controller.params.to_options.has_key?(:checked)
      end
      
      if (controller.action_name == 'create')
        test_task = Task.new(controller.params[:task])
        if(test_task.asset_id?)
          asset = test_task.asset
          if asset.respond_to?("stage")
            controller.params[:task].merge!({ :asset_status_create => asset.stage })
            controller.params[:task].merge!({ :asset_status_update => asset.stage })
          end
        end 
      end
      
      if (controller.action_name == 'update')
        test_task = Task.new(controller.params[:task])
        if(test_task.asset_id?)
          asset = test_task.asset
          if asset.respond_to?("stage")
            controller.params[:task].merge!({ :asset_status_update => asset.stage })
          end
        end 
      end
      
    end

  end

end

 
