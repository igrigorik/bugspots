require 'rainbow'
require 'grit'

module Bugspots
  Fix = Struct.new(:message, :date, :files)

  def self.scan(repo)
    puts "Scanning #{repo} repo".foreground(:green)
    repo = Grit::Repo.new(repo)
    fixes = []

    repo.commits('master', 500).each do |commit|  
      if commit.message =~ /fix(es|ed)|close(s|d)/
        files = commit.stats.files.map {|s| s.first}    
        fixes << Fix.new(commit.message, commit.date, files)        
      end
    end

    hotspots = Hash.new(0)
    fixes.each do |fix|
      fix.files.each do |file|
        t = 1 - ((Time.now - fix.date).to_f / (Time.now - fixes.last.date))
        hotspots[file] += (1/(1+Math.exp(-12*t)+12))
      end
    end

    puts "\tFound #{fixes.size} bugfix commits, with #{hotspots.size} hotspots:".foreground(:yellow)
    puts

    hotspots.sort_by {|k,v| v}.reverse.each do |spot|
      puts "\t#{spot.last.round(2)}".foreground(:red) + " - #{spot.first}".foreground(:yellow)
    end
  end
end