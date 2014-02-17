require "rugged"

module Bugspots
  Fix = Struct.new(:message, :date, :files)
  Spot = Struct.new(:file, :score)

  def self.scan(repo, branch = "master", depth = 500, regex = nil)
    regex ||= /\b(fix(es|ed)?|close(s|d)?)\b/i
    fixes = []

    repo = Rugged::Repository.new(repo)
    unless Rugged::Branch.each_name(repo).sort.find { |b| b == branch }
      raise ArgumentError, "no such branch in the repo: #{branch}"
    end

    walker = Rugged::Walker.new(repo)
    # walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)

    tip = Rugged::Branch.lookup(repo, branch).tip.oid
    walker.push(tip)

    walker.each do |commit|
      if commit.message =~ regex
        files = commit.diff(commit.parents.first).deltas.collect do |d|
          d.old_file[:path]
        end
        fixes << Fix.new(commit.message.split("\n").first, commit.time, files)
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
