
namespace :crm do

  namespace :di do

    namespace :tasks do

      def create_lookup(lookup_name, description, parent = nil, status = "Active")
        if (t = Lookup.find_by_name(lookup_name))
          puts "#{lookup_name} lookup exists"
        else
          puts "Creating #{lookup_name} lookup"
          t = (parent.nil? ? Lookup : parent.lookups).create(:name => lookup_name, :description => description, :status => status)
          t.save!
          puts "Created #{lookup_name} lookup"
        end
        return t
      end
      
      desc "Setup DI task extentions"  
      task :setup => :environment do

        puts "\n" << ("=" * 80) << "\n= Installing DI task extentions\n" << ("=" * 80)

        c = create_lookup("task.category", "Task Category")
        puts "-" * 80
        ot = create_lookup("task.category.outcometype", "Task Outcome Type", c)
        puts "-" * 80
        ost = create_lookup("task.category.outcometype.subtype", "Task Outcome Subtype", ot)

        puts ("=" * 80) << "\n= Installed DI task extentions\n" << ("=" * 80) << "\n\n"

      end


      def add_lookup_items(items, parent_lookup = nil, parent_item = nil)
        items.each do |x|
          lookup_name = x[0]
          code        = x[1]
          description = x[2]
          children    = x[3]
          parent      = Lookup
          parent      = parent_lookup.lookups unless parent_lookup.nil?
          l           = parent.find_by_name(lookup_name)

          item        = parent_lookup.nil? ? l.items.find_by_code(code.to_s) : l.items.find_by_code_and_parent_id(code, parent_item.id)
          if(item)
            puts "'#{lookup_name}' code '#{code}' exists"
            puts "-" * 80
          else
            puts "Creating '#{lookup_name}' code '#{code}'"
            item = l.items.new
            item.code = code.to_s
            item.description = description
            item.long_description = description
            item.parent_id = parent_item.nil? ? nil : parent_item.id
            item.assign_next_sequence
            item.activate
            item.save
            puts "Created '#{lookup_name}' code '#{code}'"
            puts "-" * 80
          end
          
          if !l.nil? && !children.empty?
            add_lookup_items children, l, item
          end

        end
        
      end

      
      def check_lookups_for_items(items, lookups = {  }, parent_lookup = nil)

        items.each do |x|

          lookup_name = x[0]
          children    = x[3]
          parent      = Lookup
          parent      = parent_lookup.lookups unless parent_lookup.nil?
          l           = parent.find_by_name(lookup_name)
          
          if !lookups.has_key?(lookup_name)
            puts "Checking for lookup #{lookup_name}"
            lookups[lookup_name] = !l.nil?
            if(lookups[lookup_name])
              puts "Lookup #{lookup_name} found."
            else
              puts "Lookup #{lookup_name} not found!"   
            end
            puts "-" * 80
          end
          
          if !l.nil? && !children.empty?
            lookups = check_lookups_for_items(children, lookups, l)
          end
          
        end
        
        return lookups
        
      end
      
      
      desc "Setup DI task extentions demonstation data"  
      task :demo => :environment do

        items = [
                  ['task.category', :call,         'Call',         [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]], 
                  ['task.category', :email,        'EMail',        [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]],
                  ['task.category', :follow_up,    'Follow up',    [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]],
                  ['task.category', :lunch,        'Lunch',        [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]],
                  ['task.category', :meeting,      'Meeting',      [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]],
                    ['task.category.outcometype',  'CANCELLED',        'Cancelled',        [
                      ['task.category.outcometype.subtype', 'ABANDONED',    'Abandoned',           []],
                      ['task.category.outcometype.subtype', 'RESCHEDULED',  'Rescheduled',         []]
                    ]]
                  ]],
                  ['task.category', :money,        'Money',        [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]],
                  ['task.category', :presentation, 'Presentation', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]],
                  ['task.category', :trip,         'Trip',         [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         [
                    ]]
                  ]]
                ]
 
        puts "\n" << ("=" * 80) << "\n= Installing DI task extentions demonstration data\n" << ("=" * 80)

        puts "Checking lookups\n" << ("=" * 80)
        test = check_lookups_for_items(items)
        errors = ""
        test.each {|k, v| errors << ((errors.empty? ? "" : ", ") + "'" + k + "'") if !v }

        if !errors.empty? 
          puts "Required lookup(s) #{errors} missing, run 'rake crm:di:tasks:setup' to install required lookups" 
        else
          puts "Required lookups found"
          puts "=" * 80
          puts "Adding new lookup values"
          puts "=" * 80
          add_lookup_items items
        end

        puts ("=" * 80) << "\n= " << (errors.empty? ? "Installed" : "Failed to install") << " DI task extentions demonstration data\n" << ("=" * 80) << "\n\n"

      end

    end
  
  end

end
