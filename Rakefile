$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
require 'rake'

desc 'setup the environment for the rest of the tasks'
task :environment do
  p Time.now
  require 'environment'
  require "assets"
  $redis = Redis.new(REDIS_CONFIG)
end

namespace :update do
  desc 'run the BookingsParser'
  task :bookings => ["environment", "delete:bookings"] do
    require 'bookings_parser'
    BookingsParser.run
    print "Bookingsparser finished\n".green
  end

  desc 'update all'
  task :all => ['db:flush', 'update:bookings', 'update:news']

  desc 'run the NewsParser'
  task :news => ["environment", "delete:news"] do
    require 'news_parser'
    NewsParser.run
    print "Newsparser finished\n".green
  end
  #desc 'run the ExamsParser'
  #task :exams => ["environment"] do
  #  require_relative 'lib/exams_parser'
  #  ExamsParser.run
  #  print "Examsparser finished\n".green
  #end
end

namespace :delete do
  desc 'delete all bookings'
  task :bookings => ["environment"] do
    require 'booking'
    c = Booking.delete_all
    print "#{c} Items deleted\n".yellow if c > 0
  end

  desc 'delete all news'
  task :news => ["environment"] do
    require 'news'
    c = News.delete_all
    print "#{c} Items deleted\n".yellow if c > 0
  end
  #desc 'delete all exams'
  #task :exams => ["environment"] do
  #  require_relative 'lib/exam'
  #  Exam.delete_all
  #end
end
namespace :db do
  desc 'clear all data from the choosen redis db'
  task :flush => ["environment"] do
    $redis.flushdb
    print "Database flushed\n".yellow
  end

  desc 'show some database stats'
  task :stats => ["environment"] do
    ap $redis.info
  end
  desc 'rebuild database'
  task :rebuild => ['db:flush', 'update:all']
end

namespace :assets do
  desc 'compile assets'
  task :compile => [:clean_all, :compile_js, :compile_css, :create_templates] do
  end

  desc 'compile javascript assets'
  task :compile_js => ['environment'] do
    source = 'application.js'
    require 'uglifier'
    s = sprockets
    s.js_compressor = Uglifier.new(mangle: true)
    asset     = s[source]
    outpath   = File.join(root, 'public', 'assets')
    outfile   = Pathname.new(outpath).join( asset.digest_path ) # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")

    puts "successfully compiled js assets"

    write_manifest(source,asset.digest_path)
  end

  desc 'compile css assets'
  task :compile_css => ['environment'] do
    source = 'application.css'
    require 'yui/compressor'
    s = sprockets
    s.css_compressor = YUI::CssCompressor.new
    asset     = s[source]
    outpath   = File.join(root, 'public', 'assets')
    outfile   = Pathname.new(outpath).join( asset.digest_path ) # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled css assets"
    write_manifest(source, asset.digest_path)
  end

  desc 'copy images'
  task :copy_images => ['environment'] do
    #TODO
  end

  desc 'delete compiled assets'
  task :clean_all do
    FileUtils.rm_rf File.join(root, 'public', 'assets')
    FileUtils.rm_rf File.join(root, 'public', 'templates.json')
  end

  desc "create template.json"
  task :create_templates do
    require 'json'
    File.open(File.join(root, 'public', 'templates.json'), 'w') do |f|
      f.print Dir['templates/client/*'].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) } }.to_json
    end
    puts 'templates.json created'
  end
end
def root
  File.dirname(__FILE__)
end
def sprockets
  Assets.sprockets
end
MANIFEST_PATH = File.join(root, 'public', 'assets', 'manifest.json')
def write_manifest(source,digest_path)
  require 'json'
  FileUtils.touch MANIFEST_PATH
  file = IO.read(MANIFEST_PATH)
  if file.empty?
    manifest = {}
  else
    manifest = JSON.parse(file)
  end
  manifest.merge!(source => digest_path)
  File.open(MANIFEST_PATH, 'w') do |f|
    f.print manifest.to_json
  end
end
