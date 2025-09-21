# frozen_string_literal: true

require "redis"

def running_in_docker?
  return true if File.exist?("/.dockerenv")

  if File.exist?("/proc/1/cgroup")
    File.read("/proc/1/cgroup").include?("docker")
  else
    false
  end
rescue Errno::EACCES
  false
end

REDIS_HOST = if ENV["REDIS_URL"]
  ENV["REDIS_URL"]
elsif running_in_docker?
  "redis://redis:6379/0"
else
  "redis://localhost:6379/0"
end

REDIS = Redis.new(url: REDIS_HOST)
