# frozen_string_literal: true

def gzip_file(source, target)
  Zlib::GzipWriter.open(target) do |gz|
    File.open(source, 'rb') do |f|
      while chunk = f.read(16 * 1024)
        gz.write(chunk)
      end
    end
  end

  log :info, "completed gzip of #{target}"
end
