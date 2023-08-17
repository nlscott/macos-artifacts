# frozen_string_literal: true

require_relative "artifacts/version"

module Macos
  module Artifacts
    def self.users
      users=[]
      Dir.entries("/Users").each do |username|
        if !username.start_with?(".")
          users.push(username)
        end
      end
      users.delete("Guest")
      users.delete("Shared")
      return users
    end
  end
end
