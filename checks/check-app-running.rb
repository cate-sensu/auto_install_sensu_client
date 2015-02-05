#!/usr/bin/env ruby

procs = `ps aux`
running = false
procs.each_line do |proc|
  running = true if proc.include?('worker.py')
end
if running
  puts 'OK - Worker is running'
  exit 0
else
  puts 'WARNING - Worker NOT running'
  exit 2
end