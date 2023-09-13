# frozen_string_literal: true

$currentUser = ENV['USER'] 

module Macos
  module Artifacts
    module Files

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
            plistLint = `plutil -lint #{$systemLaunchAgentsPath}/#{filename} | cut -d ":" -f2 | xargs`.strip
            if plistLint == "OK"
              puts "  #{$systemLaunchAgentsPath}/#{filename}"
              plist = CFPropertyList::List.new(:file => "#{$systemLaunchAgentsPath}/#{filename}")
              data = CFPropertyList.native_types(plist.value)
              data.each do |k,v|
                puts "    #{k}: #{v}"
              end
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
          if filename != "." && filename != ".." && filename != ".Trash" && filename != ".cups"
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

      def self.systemApplicationSupport
        systemApplicationSupport = "/Library/Application Support"
          if Dir.exist?("#{systemApplicationSupport}")
            puts "System Application Support:"
            Dir.entries("#{systemApplicationSupport}").each do  | filename |
              if filename != "." && filename != ".." && filename != ".DS_Store"
                puts "  #{systemApplicationSupport}/#{filename}"
              end
            end
          end
      end

      def self.libraryPreferences
        systemApplicationSupport = "/Library/Preferences"
        if Dir.exist?("#{systemApplicationSupport}")
          puts "Library Preferences:"
          Dir.entries("#{systemApplicationSupport}").each do  | filename |
            if filename != "." && filename != ".." && filename != ".DS_Store"
              puts "  #{systemApplicationSupport}/#{filename}"
            end
          end
        end
      end

      def self.userLibraryPreferences
        userArray = []
        Dir.entries("/Users").each do |username|
          if !username.start_with?(".")
            if username != "Shared" and username != "Guest"
              userArray.push("#{username}")
            end
          end
        end
        userArray.each do |username|
          filesArray = []
          userPreferences = "/Users/#{username}/Library/Preferences"
          if Dir.exist?("#{userPreferences}")
            puts "#{username} Preferences:"
            Dir.entries("#{userPreferences}").each do  | filename |
              if filename != "." && filename != ".." && filename != ".DS_Store"
                filesArray.push("#{userPreferences}/#{filename}")
              end
            end
          end
          filesArray.sort.each do |filename|
            puts "  #{filename}"
          end
        end
      end

      def self.cronTabs
        cronTab = `/usr/bin/crontab -l`.strip
        puts "crontabs:"
        if cronTab.empty?
          puts "  No current crontabs"
        else
          puts "  #{cronTab}"
        end
      end
      
      def self.etcHosts
        hostfiles = `cat /etc/hosts`.split("\n")
        puts "Hosts File:"
        hostfiles.each do |line|
          puts "  #{line}"
        end
      end

      def self.usrLocal
        path = "/usr/local"
        
        puts "#{path} Directory:"
        if File.exists?("#{path}")
          output = `ls -al #{path}`.split("\n")
          output.shift
          output.each do |item|
            puts "  #{item}"
          end
        else
          puts "  No such file or directory"
        end
      end

      def self.usrLocalBin
        path = "/usr/local/bin"
        
        puts "#{path} Directory:"
        if File.exists?("#{path}")
          output = `ls -al #{path}`.split("\n")
          output.shift
          output.each do |item|
            puts "  #{item}"
          end
        else
          puts "  No such file or directory"
        end
      end

      def self.usrLocalSbin
        path = "/usr/local/sbin"
        
        puts "#{path} Directory:"
        if File.exists?("#{path}")
          output = `ls -al #{path}`.split("\n")
          output.shift
          output.each do |item|
            puts "  #{item}"
          end
        else
          puts "  No such file or directory"
        end
      end

      def self.usersShared
        path = "/Users/Shared"
        
        puts "#{path} Directory:"
        if File.exists?("#{path}")
          output = `ls -al #{path}`.split("\n")
          output.shift
          output.each do |item|
            puts "  #{item}"
          end
        else
          puts "  No such file or directory"
        end
      end

      def self.privateTmp
        path = "/private/tmp"
        
        puts "#{path} Directory:"
        if File.exists?("#{path}")
          output = `ls -al #{path}`.split("\n")
          output.shift
          output.each do |item|
            puts "  #{item}"
          end
        else
          puts "  No such file or directory"
        end
      end

      def self.scriptInstallLocations
        history1 = `mdfind "kMDItemKind == 'Shell Script'"`.split("\n")
        puts "Script Install Locations:"
        history1.each do |item|
          if ! item.start_with?("/System", "/Library/Developer", "/usr/share", "/usr/bin", "/Library/Ruby")
            if ! item.include? "/Library/Application Support/Code/User/History"
                puts "  #{item.strip}"
            end
          end
        end
      
        history = `mdfind "kMDItemKind == '* Source'"`.split("\n")
        history.each do |item|
          if ! item.start_with?("/System", "/Library/Developer", "/usr/share", "/usr/bin", "/Library/Ruby")
            if ! item.include? "/Library/Application Support/Code/User/History"
              puts "  #{item.strip}"
            end
          end
        end
      end

    end
  end
end
