class Color
  class << self
    { red: 31, green: 32, yellow: 33, blue: 34, pink: 35, light_blue: 36 }.each do |color, code|
      define_method color do |string|
        colorize(string, code)
      end
    end

    def colorize(string, color_code)
      "\e[#{color_code}m#{string}\e[0m"
    end
  end
end
