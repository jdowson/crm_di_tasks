
namespace :crm do

  namespace :di do

    namespace :tasks do

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


      desc "Setup DI task extentions demonstation data"  
      task :demo => :environment do

        items = [
                  ['task.category', :call,         'Call',         '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]], 
                  ['task.category', :email,        'EMail',        '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]],
                  ['task.category', :follow_up,    'Follow up',    '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]],
                  ['task.category', :lunch,        'Lunch',        '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]],
                  ['task.category', :meeting,      'Meeting',      '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]],
                    ['task.category.outcometype',  'CANCELLED',        'Cancelled',        '', [
                      ['task.category.outcometype.subtype', 'ABANDONED',    'Abandoned',           '', []],
                      ['task.category.outcometype.subtype', 'RESCHEDULED',  'Rescheduled',         '', []]
                    ]]
                  ]],
                  ['task.category', :money,        'Money',        '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]],
                  ['task.category', :presentation, 'Presentation', '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
                    ]]
                  ]],
                  ['task.category', :trip,         'Trip',         '', [
                    ['task.category.outcometype',  'COMPLETE',         'Complete',         '', [
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
