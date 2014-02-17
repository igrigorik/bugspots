require 'grit'

module Bugspots
  Fix = Struct.new(:message, :date, :files)
  Spot = Struct.new(:file, :score)

  def self.scan(repo, branch = "master", depth = 500, regex = nil)
    repo = Grit::Repo.new(repo)
    unless repo.branches.find { |e| e.name == branch }
      raise ArgumentError, "no such branch in the repo: #{branch}"
    end
    fixes = []

    regex ||= /\b(fix(es|ed)?|close(s|d)?)\b/i

    tree = repo.tree(branch)

    commit_list = repo.git.rev_list({:max_count => false, :no_merges => true, :pretty => "raw", :timeout => false}, branch)
    Grit::Commit.list_from_string(repo, commit_list).each do |commit|
      if commit.message =~ regex
        files = commit.stats.files.map {|s| s.first}.select{ |s| tree/s }
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
