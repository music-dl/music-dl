class TagsVerifier
  MAX_DISTANCE = 3

  def initialize(track_name, path)
    @track_name = track_name
    @path = path
  end

  def verify
    track = RSpotify::Track.search(@track_name).first
    unless track
      puts(Color.red("Track \"#{@track_name}\" does not exist in spotify library"))
      return
    end

    mp3_tag = Mp3Info.open(@path).tag
    compare('name', track.name, mp3_tag.title.to_s)
    compare('artist', track.artists.map(&:name).join(', '), mp3_tag.artist.to_s)
  end

  private

  def compare(object_name, expected, got)
    print_mismatch_msg(object_name, expected, got) unless match?(expected, got)
  end

  def print_mismatch_msg(mismatch_object, expected, got)
    puts(Color.red("#{mismatch_object} mismatch in track \"#{@track_name}\" in \"#{@path}\". "\
                   "Expected: \"#{expected}\". Got in tags: \"#{got}\""))
  end

  def match?(name, sample_name)
    levenshtein(name.downcase, sample_name.downcase) < MAX_DISTANCE
  end

  # source https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance
  #
  def levenshtein(first, second)
    matrix = [(0..first.length).to_a]
    (1..second.length).each do |j|
      matrix << [j] + [0] * first.length
    end

    (1..second.length).each do |i|
      (1..first.length).each do |j|
        if first[j - 1] == second[i - 1]
          matrix[i][j] = matrix[i - 1][j - 1]
        else
          matrix[i][j] = [
            matrix[i - 1][j],
            matrix[i][j - 1],
            matrix[i - 1][j - 1]
          ].min + 1
        end
      end
    end
    matrix.last.last
  end
end
