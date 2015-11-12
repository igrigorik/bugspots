require "rugged"

module Bugspots
  Fix = Struct.new(:message, :date, :files)
  Spot = Struct.new(:file, :score)

  def self.scan(repo, branch = "master", depth = 500, regex = nil)
    regex ||= /\b(fix(es|ed)?|close(s|d)?)\b/i
    fixes = []

    repo = Rugged::Repository.new(repo)
    unless repo.branches.each_name(:local).sort.find { |b| b == branch }
      raise ArgumentError, "no such branch in the repo: #{branch}"
    end

    walker = Rugged::Walker.new(repo)
    walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
    walker.push(repo.branches[branch].target)
    walker.each do |commit|
      if commit.message.scrub =~ regex
        files = commit.diff(commit.parents.first).deltas.collect do |d|
          d.old_file[:path]
        end
        fixes << Fix.new(commit.message.scrub.split("\n").first, commit.time, files)
      end
    end

    hotspots = Hash.new(0)
    currentTime = Time.now
    fixes.each do |fix|
      fix.files.each do |file|
        # The timestamp used in the equation is normalized from 0 to 1, where
        # 0 is the earliest point in the code base, and 1 is now (where now is
        # when the algorithm was run). Note that the score changes over time
        # with this algorithm due to the moving normalization; it's not meant
        # to provide some objective score, only provide a means of comparison
        # between one file and another at any one point in time
        t = 1 - ((currentTime - fix.date).to_f / (currentTime - fixes.first.date))
        hotspots[file] += 1/(1+Math.exp((-12*t)+12))
      end
    end

    spots = hotspots.sort_by {|k,v| v}.reverse.collect do |spot|
      Spot.new(spot.first, sprintf('%.4f', spot.last))
    end

    return fixes, spots
  end
end
