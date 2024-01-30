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
            $extType = line[1]
          elsif !line.start_with?("enabled")
            line = line.split(" ")
            if line[0] = "*"
              extEnabled = "true"
            else
              extEnabled = "false"
            end
            if line[1] = "*"
              extActive = "true"
            else
              extActive = "false"
            end
            teamID = line[2]
            bunldeID = line[3]
            versionExt = line[4]
        
            if line[5] != "[activated"
              if line[6] != "[activated"
                if line[7] != "[activated"
                  if line[8] != "[activated"
                    nameExt = "#{line[5]} #{line[6]} #{line[7]} #{line[8]}"
                  else
                    nameExt = "#{line[5]} #{line[6]} #{line[7]}"
                  end
                end
              else
                nameExt = "#{line[5]}"
              end
            else
              nameExt = "#{line[5]}"
            end
      
            if line[6] == "[activated"
              stateExt = "#{line[6]} #{line[7]}"
            elsif line[7]  == "[activated"
              stateExt = "#{line[7]} #{line[8]}"
            elsif line[8]  == "[activated"
              stateExt = "#{line[8]} #{line[9]}"
            elsif line[9]  == "[activated"
              stateExt = "#{line[9]} #{line[10]}"
            else
              stateExt = "#{line[6]} #{line[7]}"
            end
            puts "  Type: #{$extType}"
            puts "    Enabled: #{extEnabled}"
            puts "    Active: #{extActive}"
            puts "    Team ID: #{teamID}"
            puts "    Bundle ID: #{bunldeID}"
            puts "    Version:  #{versionExt}"
            puts "    Name: #{nameExt}"
            puts "    State: #{stateExt}"
          end
          
       end
       
      
      end

      def self.processCPU
        $psArray = []
        $psHash = {}
        processes = `ps axc -o user,pid,%cpu,%mem,start,time,command`.split("\n")
        processes.shift()
      
        processes.each do |item|
          data = item.split(" ")
          psHash = {
            :user => "#{data[0].strip}",
            :pid => "#{data[1].strip}",
            :cpu => "#{data[2].to_f}",
            :mem => "#{data[3].strip}",
            :start => "#{data[4].strip}",
            :time => "#{data[5].strip}",
            :command => "#{data[6].strip}"
          }
          $psArray.push(psHash)
        end
      
        $psArray.sort_by! { |hash| hash[:cpu] }
        puts "Top 10 CPU Processes:"
      
        $psArray.last(10).reverse.each do |ps|
          ps.each do |key,value|
            if key.to_s == "user"
               puts "  #{key}: #{value}"
            else
              puts "    #{key}: #{value}"
            end
          end
        end
      end

      def self.processMemory
        $psArray = []
        $psHash = {}
        processes = `ps axc -o user,pid,%cpu,%mem,start,time,command`.split("\n")
        processes.shift()
      
        processes.each do |item|
          data = item.split(" ")
          psHash = {
            :user => "#{data[0].strip.to_s}",
            :pid => "#{data[1].strip}",
            :cpu => "#{data[2].to_f}",
            :mem => "#{data[3].strip}",
            :start => "#{data[4].strip}",
            :time => "#{data[5].strip}",
            :command => "#{data[6].strip}"
          }
          $psArray.push(psHash)
        end
      
        $psArray.sort_by! { |hash| hash[:mem] }
        puts "Top 10 Memory Processes:"
      
        $psArray.last(10).reverse.each do |ps|
          ps.each do |key,value|
            if key.to_s == "user"
               puts "  #{key}: #{value}"
            else
              puts "    #{key}: #{value}"
            end
          end
        end
      end

      def self.openNetworkConnections
        listOfOpenConnections = `lsof -i`.split("\n")
        listOfOpenConnections.shift
        puts "Open Network Connections:"
        listOfOpenConnections.each do |line|
          line = line.split(" ")
          puts "  Command: #{line[0]}"
          puts "    PID: #{line[1]}"
          puts "    USER: #{line[2]}"
          puts "    TYPE: #{line[4]}"
          puts "    NODE: #{line[7]}"
          puts "    NAME: #{line[8]}"
        end 
      end

      def self.networkInterfaces
        listOfNetworkInterfaces = `ifconfig`.split("\n")
        puts "Network Interfaces:"
        listOfNetworkInterfaces.each do |item|
          if item.start_with?(/^*:/)
            puts item.strip
          else
            puts "  #{item}"
          end
        end
      end

    end
  end
end
