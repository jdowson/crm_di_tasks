
module CRMDITasks

  module FFViewHelpers

    def tasks_side_bar_item(caption, id)
      "<div>#{caption}: <b style='color:#{lkup_color(id)}'>#{lkup_ld(id)}</b></div>" unless id.nil?
    end

  end

end

ActionView::Base.send(:include, CRMDITasks::FFViewHelpers)
