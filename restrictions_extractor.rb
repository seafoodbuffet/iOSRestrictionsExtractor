#!/usr/bin/env ruby

begin
  require 'bundler/inline'
rescue LoadError => e
  $stderr.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true) do
  source 'https://rubygems.org'
  gem 'pbkdf2', github: 'emerose/pbkdf2-ruby'
end

require 'base64'

class RestrictionsPasscodeCracker
  def recover_restrictions_passcode(password_key, salt)
    decoded_salt = Base64.decode64(salt)

    stop = false
    found_passcode = nil
    i = 0
    while !stop
      try_pass = i.to_s.rjust(4, "0")

      print "#{try_pass}\r"
      $stdout.flush

      pbkdf2 = PBKDF2.new(:password => try_pass, :salt => decoded_salt, :hash_function => :sha1, :key_length => 20, :iterations => 1000)
      str = Base64.encode64(pbkdf2.bin_string).chomp
      if password_key.eql? str
        found_passcode = try_pass
        stop = true
      else
        i = i + 1
      end
      if i > 9999
        puts "didn't find code, are you sure you entered the key and salt correctly?"
        stop = true
      end
    end
    found_passcode
  end
end

if ARGV.length != 2
  puts "Usage: restrictions_extractor.rb <encoded passcode key> <passcode salt>"
  exit
end

key = ARGV[0]
salt = ARGV[1]

puts "okay, let's get crackin"
crack = RestrictionsPasscodeCracker.new
passcode = crack.recover_restrictions_passcode(key, salt)
if passcode.nil?
  puts "couldn't find the passcode, both the key and salt should be valid base64-encoded inputs"
else
  puts "found the passcode!, it's: #{passcode}"
end
