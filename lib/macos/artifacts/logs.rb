# frozen_string_literal: true

$currentUser = ENV['USER'] 

module Macos
  module Artifacts
    module Logs
      def self.systemLaunchAgents
        $systemLaunchAgentsPath = "/Library/LaunchAgents"
        $launchAgentDir = Dir.entries("#{$systemLaunchAgentsPath}")
        puts "System Launchagents:"
        $launchAgentDir.each do  | filename |
          if filename != "." && filename != ".."
            puts "  #{$systemLaunchAgentsPath}/#{filename}"
            plist = CFPropertyList::List.new(:file => "#{$systemLaunchAgentsPath}/#{filename}")
            data = CFPropertyList.native_types(plist.value)
            data.each do |k,v|
              puts "    #{k}: #{v}"
            end
          end
        end
      end

      def self.systemLaunchDaemons
        $systemLaunchAgentsPath = "/Library/LaunchDaemons"
        $launchAgentDir = Dir.entries("#{$systemLaunchAgentsPath}")
        puts "System LaunchDaemons:"
        $launchAgentDir.each do  | filename |
          if filename != "." && filename != ".."
            puts "  #{$systemLaunchAgentsPath}/#{filename}"
            plist = CFPropertyList::List.new(:file => "#{$systemLaunchAgentsPath}/#{filename}")
            data = CFPropertyList.native_types(plist.value)
            data.each do |k,v|
              puts "    #{k}: #{v}"
            end
          end
        end
      end

      def self.userLaunchAgents
        userArray = []
        Dir.entries("/Users").each do |username|
          if !username.start_with?(".")
            if username != "Shared" and username != "Guest"
              userArray.push("#{username}")
            end
          end
        end
      
        userArray.each do |username|
          userLaunchAgentsPath = "/Users/#{username}/Library/LaunchAgents"
          if Dir.exist?("#{userLaunchAgentsPath}")
            launchAgentDir = Dir.entries("#{userLaunchAgentsPath}")
            puts "#{username} LaunchAgents:"
            launchAgentDir.each do  | filename |
              if filename != "." && filename != ".." && filename != ".DS_Store"
                puts "  #{userLaunchAgentsPath}/#{filename}"
                plist = CFPropertyList::List.new(:file => "#{userLaunchAgentsPath}/#{filename}")
                data = CFPropertyList.native_types(plist.value)
                data.each do |k,v|
                  puts "    #{k}: #{v}"
                end
              end
            end
          end
      
        end
      end

      def self.listUsersAccountDirectory
        $userHomeFolder = Dir.entries("/Users/#{$currentUser}")
        fileArray = []
        $userHomeFolder.each do  | filename |
          if filename != "." && filename != ".."
            filePath = "/Users/#{$currentUser}/#{filename}"
              fileArray.push("#{filePath}")
          end
        end
    
        fileArray = fileArray.sort
    
        puts "Home Directory for #{$currentUser}:"
        fileArray.each do |item|
          if ! Dir.exist?("#{item}")
            puts "  #{item}"
          elsif Dir.exist?("#{item}")
            puts "  #{item}:"
            $subDir = Dir.entries("#{item}")
            $subDir.each do  |subfile|
              if subfile != "." && subfile != ".."
                puts "    #{item}/#{subfile}"
              end
            end
          else
            puts "ERROR"
          end
        end
      end

      def self.userApplicationSupport
        userApplicationSupport = "/Users/#{$currentUser}/Library/Application Support"
        if Dir.exist?("#{userApplicationSupport}")
          puts "#{$currentUser} Application Support:"
          Dir.entries("#{userApplicationSupport}").each do  | filename |
            if filename != "." && filename != ".." && filename != ".DS_Store"
              puts "  #{userApplicationSupport}/#{filename}"
            end
          end
        end
      end

    end
  end
end
