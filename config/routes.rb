
ActionController::Routing::Routes.draw do |map|

  map.match   'tasks/complete_confirm/:id',        :controller => 'tasks', :action => 'complete_confirm'
  map.match   'tasks/complete_confirm_update/:id', :controller => 'tasks', :action => 'complete_confirm_update'

end
