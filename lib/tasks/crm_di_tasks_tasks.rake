
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


      desc "Setup DI task extentions demonstation data"  
      task :demo => :environment do

        puts "\n" << ("=" * 80) << "\n= Installing DI task extentions demonstration data\n" << ("=" * 80)

        errors = ""

        if (t = Lookup.find_by_name("task.type"))
          if !(s = t.lookups.find_by_name("task.type.subtype"))
            errors << "task.type.subtype lookup does not exist\n"
          end
        else
          errors << "task.type lookup does not exist\n"
        end

        errors << (errors.empty? ? "" : "Run 'rake crm:di:tasks:setup to install required lookups")

        if !errors.empty? 
          puts errors
        else

          puts "Required lookups found"

          %w(Client Prospect Supplier Partner).each do |type|

            puts "-" * 80
            code = type.upcase
            desc = "#{type} Description"

            if(ti = t.items.find_by_code(code))
              puts "Task type '#{type}' exists"
            else
              puts "Creating task type '#{type}'"
              ti = t.items.new
              ti.code = code
              ti.description = type
              ti.long_description = desc
              ti.assign_next_sequence
              ti.activate
              ti.save
              puts "Created task type '#{type}'"
            end

            subtypes = case code
              when "CLIENT"   then %w(VIP Premier Regular Blacklist)
              when "PROSPECT" then []
              when "SUPPLIER" then %w(Approved Unapproved)
              when "PARTNER"  then %w(Channel Franchise Brand)
              else []
            end

            subtypes.each do |subtype|

              scode = code + ":" + subtype.upcase
              sdesc = "#{type}/#{subtype} Description"

              if(si = s.items.find_by_code_and_parent_id(scode, ti.id))
                puts "Task subtype '#{type}/#{subtype}' exists"
              else
                puts "Creating Task subtype '#{type}/#{subtype}'"
                si = s.items.new
                si.parent_id = ti.id
                si.code = scode
                si.description = subtype
                si.long_description = sdesc
                si.assign_next_sequence
                si.activate
                si.save
                puts "Created Task subtype '#{type}/#{subtype}'"
              end

            end

          end

        end
 
        puts ("=" * 80) << "\n= " << (errors.empty? ? "Installed" : "Failed to install") << " DI task extentions demonstration data\n" << ("=" * 80) << "\n\n"

      end


    end
  
  end

end
