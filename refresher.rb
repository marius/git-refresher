#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

# Globally set some ssh parameters for git
ENV['GIT_SSH_COMMAND'] =
  'ssh -i /run/secrets/postfix-sendgrid_deploy_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Function to perform the git operations
def perform_git_operations
  # Checkout or create the 'gh_refresh' branch
  system 'git checkout gh_refresh || git checkout -b gh_refresh', exception: true

  # Perform an empty commit
  system 'git commit --allow-empty -m "Refresh branch"', exception: true

  # Push the branch to the remote repository
  system 'git push origin gh_refresh', exception: true
end

# Function to calculate if 58 days have passed since the last commit
def time_to_commit?
  last_commit_date_str = `git log -1 --format=%cd`
  last_commit_date = Date.parse(last_commit_date_str)
  (Date.today - last_commit_date).to_i >= 58
end

system "git clone #{ENV['GIT_REPOSITORY']} repo", exception: true unless File.directory? 'repo'

Dir.chdir 'repo'

# Main execution logic
loop do
  begin
    if time_to_commit?
      perform_git_operations
    else
      puts 'No need to refresh the branch yet.'
    end
  rescue SystemCallError => e
    puts "An error occurred: #{e.message}"
    exit 1
  end

  puts 'Sleeping for 1 day'
  sleep 86_400
end
