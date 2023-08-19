# frozen_string_literal: true

module Macos
  module Artifacts
    module State
      def self.users
        $userHash={}
        Dir.entries("/Users").each do |username|
          if !username.start_with?(".")
            if username != "Shared" and username != "Guest"
              uid = `id -u #{username}`.strip
              $userHash["#{username}"] = uid
            end
          end
        end
      
        puts "Local Users:"
        $userHash.each do |key, value|
          puts "  #{key}: #{value}"
        end
      end

      def self.adminUsers
          admins=`dscl . -read /Groups/admin GroupMembership`.split(" ")
          admins.shift()
        
          puts "Admins:"
          admins.each do |name|
            puts "  #{name}"
          end
      end

      def self.systemExtensions
        sysext = `systemextensionsctl list`.split("\n")
        sysext.shift()
        
        puts "System Extensions:"
        sysext.each do |line|
      
          if line.start_with?('---')
            line = line.split(" ")
            puts "  Type: #{line[1]}"
          elsif !line.start_with?("enabled")
            line = line.split(" ")
            if line[0] = "*"
              puts "  Enabled: true"
            else
              puts "  Enabled: false"
            end
            if line[1] = "*"
              puts "  Active: true"
            else
              puts "  Active: false"
            end
            puts "  TeamID: #{line[2]}"
            puts "  BundleID: #{line[3]}"
            puts "  Version: #{line[4]}"
      
            if line[5] != "[activated"
              if line[6] != "[activated"
                if line[7] != "[activated"
                  if line[8] != "[activated"
                    puts "  Name: #{line[5]} #{line[6]} #{line[7]} #{line[8]}"
                  else
                    puts "  Name: #{line[5]} #{line[6]} #{line[7]}"
                  end
                end
              else
                puts "  Name: #{line[5]}"
              end
            else
              puts "  Name: #{line[5]}"
            end
      
            if line[6] == "[activated"
              puts "  State: #{line[6]} #{line[7]}"
            elsif line[7]  == "[activated"
              puts "  State: #{line[7]} #{line[8]}"
            elsif line[8]  == "[activated"
              puts "  State: #{line[8]} #{line[9]}"
            elsif line[9]  == "[activated"
              puts "  State: #{line[9]} #{line[10]}"
            else
              puts "  State: #{line[6]} #{line[7]}"
            end
          end
       end
      end
    end
  end
end