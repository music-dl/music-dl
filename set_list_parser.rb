require "pdf-reader"

Artist = Struct.new(:name, :songs)
Song = Struct.new(:title)

class SetListParser
  EXCLUDE_LINES = [/Rock Star Set List/]
  RIGHT_OFFSET = 50

  attr_reader :reader, :lines

  def initialize(path)
    @reader = PDF::Reader.new(path)
  end

  def parse
    entries = []

    reader.pages.each do |page|
      left_rows = []
      right_rows = []

      page.text.lines.each do |full_line|
        next if EXCLUDE_LINES.any? { |regex| full_line =~ regex }

        left_col = process_line_part(full_line[0...RIGHT_OFFSET])
        right_col = process_line_part(full_line[RIGHT_OFFSET..-1])

        left_rows << left_col if left_col
        right_rows << right_col if right_col
      end

      entries += left_rows + right_rows
    end

    artists = []
    last_artist = nil

    entries.each do |entry|
      case entry[0]
      when :artist
        last_artist = Artist.new(entry[1], [])
        artists << last_artist
      when :song
        last_artist.songs << Song.new(entry[1])
      end
    end

    artists
  end

  private

  def process_line_part(line)
    return if line.nil? || line.empty?

    value = line.strip
    return if value.empty?

    if line.start_with?(" ")
      [:song, value]
    else
      [:artist, value]
    end
  end
end

parser = SetListParser.new("/Users/user/Downloads/RockStar_SetList_30_04.pdf")
artists = parser.parse
songs = artists.flat_map do |artist|
  artist.songs.map { |song| "#{artist.name} - #{song.title}" }
end

File.write('set_list.txt', songs.join("\n"))
