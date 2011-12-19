require 'rainbow'
require 'grit'

module Bugspots
  Fix = Struct.new(:message, :date, :files)
  Spot = Struct.new(:file, :score)

  def self.scan(repo, branch = "master", depth = 500, words = nil)
    repo = Grit::Repo.new(repo)
    fixes = []

    if words
      message_matchers = /#{words.split(',').join('|')}/
    else
      message_matchers = /fix(es|ed)?|close(s|d)?/i
    end

    repo.commits(branch, depth).each do |commit|  
      if commit.message =~ message_matchers
        files = commit.stats.files.map {|s| s.first}    
        fixes << Fix.new(commit.short_message, commit.date, files)
      end
    end

    hotspots = Hash.new(0)
    fixes.each do |fix|
      fix.files.each do |file|
        t = 1 - ((Time.now - fix.date).to_f / (Time.now - fixes.last.date))
        hotspots[file] += 1/(1+Math.exp((-12*t)+12))
      end
    end

    spots = hotspots.sort_by {|k,v| v}.reverse.collect do |spot|
      Spot.new(spot.first, sprintf('%.4f', spot.last))
    end

    return fixes, spots
  end
end
