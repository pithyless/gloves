#!/usr/bin/env ruby

# FIXME: Bundler and RVM not playing well together
#
# require 'bundler'
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end

require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

task :default => [:test, :fingers]

task :fingers do
  ruby "main.rb"
end
