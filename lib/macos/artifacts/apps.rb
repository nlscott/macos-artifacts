# frozen_string_literal: true

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
              plist = CFPropertyList::List.new(:file => "#{$applicationsPath}/#{filename}/Contents/Info.plist")
              data = CFPropertyList.native_types(plist.value)
              data.each do |k,v|
                if k == "CFBundleShortVersionString"
                  puts "  #{$applicationsPath}/#{filename}: #{v}"
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
        history = `system_profiler SPInstallHistoryDataType `.split("\n")
        history.shift
        history.shift
        puts "Application Install History:"
        history.each do |item|
          item = item.strip
          if ! item.empty?
            if item.start_with?(/^Version:/)
              puts "    #{item}"
            elsif item.start_with?(/^Source:/)
              puts "    #{item}"
            elsif item.start_with?(/^Install Date:/)
              puts "    #{item}"
            else
              puts "  #{item}"
            end
          end
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
      

    end
  end
end
