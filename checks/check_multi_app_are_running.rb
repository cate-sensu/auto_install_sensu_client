#!/usr/bin/env ruby

procs = `ps aux`
running = []
apps = ['push', 'emails']
procs.each_line do |proc|
  apps.each do |worker|
    running.push(worker) if proc.include?(worker)
  end
end
running.uniq!
not_running = apps - running

if not_running.length == 0
  puts 'OK - All Apps running'
  exit 0
else
  puts "ERROR - One of the Apps is not running. list of not_running apps #{not_running}"
  exit 2
end