# frozen_string_literal: true

require 'json'
require 'date'
$currentUser = ENV['USER'] 

module Macos
  module Artifacts
    module Apps
      def self.applications
        $applicationsPath = "/Applications"
        $applicationsDirectory = Dir.entries("#{$applicationsPath}")
        puts "Applications Folder:"
        $applicationsDirectory.sort!.each do  | filename |
            if ! filename.start_with?(".")
            if File.extname(filename) == ".app"
                plistfile = "#{$applicationsPath}/#{filename}/Contents/Info.plist"
                if File.exist?("#{plistfile}")
                    plist = CFPropertyList::List.new(:file => "#{$applicationsPath}/#{filename}/Contents/Info.plist")
                    data = CFPropertyList.native_types(plist.value)
                    data.each do |k,v|
                        if k == "CFBundleShortVersionString"
                            puts "  #{$applicationsPath}/#{filename}: #{v}"
                        end
                    end
                end
    
            else
                if File.directory?("#{$applicationsPath}/#{filename}")
                puts "  #{$applicationsPath}/#{filename}:"
                subpath =  Dir.entries("#{$applicationsPath}/#{filename}")
                subpath.each do |subdirapp|
                    if ! subdirapp.start_with?(".")
                    if File.extname(subdirapp) == ".app"
                        plist = CFPropertyList::List.new(:file => "#{$applicationsPath}/#{filename}/#{subdirapp}/Contents/Info.plist")
                        data = CFPropertyList.native_types(plist.value)
                        data.each do |k,v|
                        if k == "CFBundleShortVersionString"
                            puts "    #{$applicationsPath}/#{filename}/#{subdirapp}: #{v}"
                        end
                        end
                    end
                    end
                end
                end
            end
            end
        end
      end

      def self.packagesReceipts
        pkgReceipts = `pkgutil --packages`.split("\n") 
        pkgReceipts.sort!
        puts "Package Receipts: "
      
        pkgReceipts.each do |pkg|
          puts "  #{pkg.strip}"
        end
      end

      def self.installHistory
        time =  DateTime.now
        installs = `system_profiler -json SPInstallHistoryDataType`.strip
        data = JSON.parse(installs)

        puts "Software Install History:"
        data["SPInstallHistoryDataType"].each do |item|
            date = item["install_date"]
            parsed_date = DateTime.parse(date)
            installsDays =  (time - parsed_date).to_i
          
            puts "  Name: #{item["_name"]}"
            puts "  Install Days: #{installsDays}"
            puts "  Install Date: #{item["install_date"]}"
            puts "  Version: #{item["install_version"]}"
            puts "  Install Source: #{item["package_source"]}"
            puts ""
        end
      end

      def self.appInstallLocations
        history = `mdfind "kMDItemKind == Application"`.split("\n")
        puts "Application Install Locations:"
        history.each do |item|
        if ! item.start_with?("/System")
            puts "  #{item.strip}"
          end
        end
      end

      def self.userInstalledApplications
        history = `mdfind -onlyin /Users/"#{$currentUser}" 'kMDItemKind == "Application"'`.split("\n")
        puts "User Installed Applications:"
        history.each do |item|
          puts "  #{item.strip}"
        end
      end
  
    end
  end
end
