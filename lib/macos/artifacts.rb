# frozen_string_literal: true

require_relative "artifacts/version"
require_relative "artifacts/state"
require 'cfpropertylist'

$currentUser = ENV['USER'] 
# $userApplicationFolder = "/Users/#{$currentUser}/Applications"
# $userDesktopFolder = "/Users/#{$currentUser}/Desktop"
# $userDownloadsFolder = "/Users/#{$currentUser}/Downloads"
# $userDocumentsFolder = "/Users/#{$currentUser}/Documents"



module Macos
  module Artifacts
    
    module Facts
      def self.computerName
        computerName = `scutil --get ComputerName`.strip
        puts "Host Name: #{computerName}"
      end

      def self.serial
        serialNumber = `system_profiler SPHardwareDataType | grep Serial | cut -d ":" -f2 | xargs`.strip
        puts "Serial: #{serialNumber}"
      end

      def self.version
        osVersion = `sw_vers -ProductVersion`.strip
        puts "Version: #{osVersion}"
      end

      def self.build
        osBuild = `sw_vers -BuildVersion`.strip
        puts "Build: #{osBuild}"
      end

      def self.kernel
        arch = `uname -r`.strip
        puts "Kernel: #{arch}"
      end

      def self.modelName
        modelName = `system_profiler SPHardwareDataType | grep "Model Name" | cut -d ":" -f2 | xargs`.strip
        puts "Model Name: #{modelName}"
      end

      def self.modelID
        modelID =  `system_profiler SPHardwareDataType | grep "Model Identifier" | cut -d ":" -f2 | xargs`.strip
        puts "Model ID: #{modelID}"
      end

      def self.chip
        chipArch = `system_profiler SPHardwareDataType | grep "Chip" | cut -d ":" -f2 | xargs`.strip
        puts "Chip: #{chipArch}"
      end

      def self.architecture
        arch = `uname -m`.strip
        puts "Architecture: #{arch}"
      end

      def self.memory
        memory = `system_profiler SPHardwareDataType | grep "Memory" | cut -d ":" -f2 | xargs`.strip
        puts "Memory: #{memory}"
      end

      def self.hardwareUID
        uuid = `system_profiler SPHardwareDataType | grep "Hardware" | cut -d ":" -f2 | xargs`.strip
        puts "Hardware UID: #{uuid}"
      end

      def self.publicIP
        ip = `dig -4 TXT +short o-o.myaddr.l.google.com $ns1.google.com | tr -d '"'`.strip
        puts "Public IP: #{ip}"
      end

      def self.privateIP
        ip = `ipconfig getifaddr en0`.strip
        puts "Private IP: #{ip}"
      end

      def self.sipStatus
        command = `csrutil status | cut -d ":" -f2 | xargs | head -c7 | xargs`.strip
        puts "SIP Status: #{command}"
      end

      def self.filevaultStatus
        command = `fdesetup status | awk '{print $3}' | head -c2 | xargs`.strip
        puts "FireVault Status: #{command}"
      end

      def self.firewallStatus
        command =  `defaults read /Library/Preferences/com.apple.alf globalstate`.strip

        if command == "0"
          puts "Firewall Status: Off"
        else
          puts "Firewall Status: On"
        end
      end

      def self.lockStatus
        status = `system_profiler SPHardwareDataType | grep "Activation Lock Status" | cut -d ":" -f2 | xargs`.strip
        puts "Activation Lock Status:"
        puts "  #{status}"
      end

      def self.screenlockStatus
        screensaverPlist = "/Library/Managed Preferences/com.apple.screensaver.plist"

        if File.exists?("#{screensaverPlist}")
          screenSaverTime = `defaults read '#{screensaverPlist}' askForPasswordDelay`.strip
          puts "found"
        else
          $askForPasswordStatus = `sysadminctl -screenLock status 2>&1 >/dev/null`.split("]")
          puts "Screen Lock Status: #{$askForPasswordStatus[1].strip}"
        end
      end

      def self.softwareUpdates
        managedUpdates = "/Library/Managed Preferences/com.apple.SoftwareUpdate.plist"
      
        puts "Software Updates:"
        if File.exists?("#{managedUpdates}")
          autoCheck = `defaults read "#{managedUpdates}" AutomaticCheckEnabled`.strip
          automaticDownload = `defaults read "#{managedUpdates}" AutomaticDownload`.strip
          automaticallyInstallMacOSUpdates = `defaults read "#{managedUpdates}" AutomaticallyInstallMacOSUpdates`.strip
          configDataInstall = `defaults read "#{managedUpdates}" ConfigDataInstall`.strip
          criticalUpdateInstall = `defaults read "#{managedUpdates}" CriticalUpdateInstall`.strip
          puts "  Auto Updates: #{autoCheck}"
          puts "  Auto Download: #{automaticDownload}"
          puts "  Auto Install: #{automaticallyInstallMacOSUpdates}"
          puts "  Install Config Data: #{configDataInstall}"
          puts "  Install Critical Updates: #{criticalUpdateInstall}"
        else
          autoCheck = `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled`.strip
          automaticDownload = `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload`.strip
          automaticallyInstallMacOSUpdates = `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates`.strip
          configDataInstall = `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall`.strip
          criticalUpdateInstall = `defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall`.strip
          puts "  Auto Updates: #{autoCheck}"
          puts "  Auto Download: #{automaticDownload}"
          puts "  Auto Install: #{automaticallyInstallMacOSUpdates}"
          puts "  Install Config Data: #{configDataInstall}"
          puts "  Install Critical Updates: #{criticalUpdateInstall}"
        end
      end

      
      
     
      
    end

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
