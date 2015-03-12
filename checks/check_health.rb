#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   check-app-health
#
# DESCRIPTION:
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'net/http'

class CheckHealth < Sensu::Plugin::Check::CLI
  option :url,
  		 proc: proc(&:to_s),
  		 default: 'http://localhost:5000/health_check/' 

  option :warn,
         short: '-w WARN',
         proc: proc(&:to_i),
         default: 10

  option :crit,
         short: '-c CRIT',
         proc: proc(&:to_i),
         default: 5

  def run
    url = URI.parse(config[:url])
    req = Net::HTTP::Get.new(url.to_s)
    start_time = Time.now
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}

    elapsed_time = Time.now - start_time

    critical if elapsed_time > config[:crit]
    warning if elapsed_time > config[:warn]
    ok
  end
end