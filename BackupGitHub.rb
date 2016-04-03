#!/usr/bin/ruby

require 'rubygems'
require 'octokit'
require 'open-uri'
require 'optparse'

options = {}
OptionParser.new do |parser|
	parser.on('--dst DESTANATION_FOLDER') do |dst|
		puts "Destination folder: #{dst}"
		DESTANATION_FOLDER = dst
	end
	parser.on('--oauth OAUTH_TOKEN') do |oauth|
		puts "OAUTH_TOKEN: ***"
		OAUTH_TOKEN = oauth
	end
end.parse!

client = Octokit::Client.new(:access_token => OAUTH_TOKEN)
user = client.user
user.login

repositories = client.repositories

repositories.each do |repository|
	archive_link = client.archive_link(repository.full_name)
	destanation_file = "#{DESTANATION_FOLDER}/#{repository.name}.tar.gz"
	puts "Backing up #{repository.name} at #{destanation_file}..."
	open(destanation_file, 'wb') do |archive_file|
		archive_file << open(archive_link).read
	end
	puts "Done backing up #{repository.name}."
end
