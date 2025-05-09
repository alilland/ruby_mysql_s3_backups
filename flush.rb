# frozen_string_literal: true


def flush(backup_dir)
  if Dir.exist?(backup_dir)
    Dir.foreach(backup_dir) do |file|
      next if file == '.' || file == '..'
      path = File.join(backup_dir, file)
      FileUtils.rm_rf(path)
    end
    log :debug, "Flushed contents of #{backup_dir}"
  else
    log :debug, "Directory does not exist: #{backup_dir}"
  end
end
