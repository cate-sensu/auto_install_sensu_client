#!/usr/bin/env ruby

## also checks for number of instances running and fixes if needed
number_of_workers = 8
procs = `ps aux`
running = false
number_of_workers_running = 0
procs.each_line do |proc|
  #running = true if proc.include?('uWSGI_config')
  if proc.include?('gunicorn')
    running = true
    number_of_workers_running += 1
  end
end
if running
  puts 'OK - DAL is running'
  exit 0
else
  puts 'WARNING - DAL NOT running'
  exit 2
end

if number_of_workers_running < number_of_workers
  increase_by = number_of_workers - number_of_workers_running
  master_pid = `cat /apps/DAL/Server/master.pid`
  puts "WARNING -NUMBER of workers (#{number_of_workers_running}) is lower than #{number_of_workers} . increase by #{increase_by}"
  (1..increase_by).each do |i|
    `kill -TTIN #{master_pid}`
  end
  exit 1

end