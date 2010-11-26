
class TasksController < ApplicationController

  #----------------------------------------------------------------------------
  # GET /tasks/complete_confirm                                            HTML
  #----------------------------------------------------------------------------
  def complete_confirm

    @task = Task.find(params[:id])

    @buttons = [
      {
        :action  => :script,
        :value   => :complete,
        :method  => "Modalbox.hide()",
        :type    => :n,
        :caption => t(:button_complete, :scope => [:di, :tasks]),
        :icon    => :tick
      },
      {
        :action  => :script,
        :value   => :no_complete,
        :method  => "Modalbox.hide()",
        :type    => :n,
        :caption => t(:button_no_complete, :scope => [:di, :tasks]),
        :icon    => :clock
      },
      { 
        :action  => :script,
        :method  => "Modalbox.hide();",
        :type    => :n,
        :caption => t(:button_cancel, :scope => [:di, :tasks]),
        :icon    => :cross
      }  
    ]

    respond_to do |format|
      format.js   { render :complete_confirm, :layout => false, :content_type => 'text/html' }
      format.html { render :complete_confirm, :layout => false, :content_type => 'text/html' }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  #----------------------------------------------------------------------------
  # PUT /tasks/complete_confirm_update/1                                   
  # PUT /tasks/complete_confirm_update/1.xml                               AJAX
  #----------------------------------------------------------------------------
  def complete_confirm_update

    action_type   = ((params[:button] ||= "").empty? ? "cancel" : params[:button]).to_sym
    render_action = (action_type == :complete) ? :complete : :update
    
    @view = params[:view] || "pending"
    @task = Task.tracked_by(@current_user).find(params[:id])
    @task_before_update = @task.clone

    update_ok = true
    
    if (@task && action_type != :cancel)

      complete_attrs = (action_type == :complete) ? { :completed_at => Time.now, :completed_by => @current_user.id } : { }
      
      if @task.due_at && (@task.due_at < Date.today.to_time)
        @task_before_update.bucket = "overdue"
      else
        @task_before_update.bucket = @task.computed_bucket
      end

      if (update_ok = @task.update_attributes(params[:task].merge(complete_attrs)))
        @task.bucket = @task.computed_bucket
        if called_from_index_page?
          if Task.bucket_empty?(@task_before_update.bucket, @current_user, @view)
            @empty_bucket = @task_before_update.bucket
          end
        end
      end
    
      update_sidebar unless !update_ok

    end
    
    respond_to do |format|
      if update_ok
        format.js   { render :action => render_action } # update.js.rjs or complete.js.rjs
        format.xml  { head :ok }
      else
        format.js   { render :action => render_action } # update.js.rjs or complete.js.rjs
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end


  def complete_mong
    @task = Task.tracked_by(@current_user).find(params[:id])
    @task.update_attributes(:completed_at => Time.now, :completed_by => @current_user.id) if @task

    # Make sure bucket's div gets hidden if it's the last completed task in the bucket.
    if Task.bucket_empty?(params[:bucket], @current_user)
      @empty_bucket = params[:bucket]
    end

    update_sidebar unless params[:bucket].blank?
    respond_to do |format|
      format.js   # complete.js.rjs
      format.xml  { head :ok }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

end