class ChromeBookmarks < Plugin
  requires_version '1.0.4'

  class << self

    def register(path)
      name = ''
      url = ''

      File.open(path) do |file|
        file.each_line do |line|
          if line =~ /"name":/
            name = get_name(line)
          elsif line =~ /"url":/
            url = get_url(line)
            create_command(name, url)
          end
        end
      end
    end

    def get_name(line)
      line.scan(/\: \"(.*)\",$/)[0][0]
    end

    def get_url(line)
      matches = line.scan(/\: \"(http.*)\"$/)[0]
      matches.nil? ? nil : matches[0]
    end

    def create_command(name, url)
      eval("command(\"#{name}\") {system('open \"#{url}\" ')}") unless url.nil?
    end

  end

end
