# frozen_string_literal: true

require_relative './settings'

# Load MySQL credentials from environment
MYSQL_USER     = ENV.fetch('MYSQL_USER')
MYSQL_PASS     = ENV.fetch('MYSQL_PASS')
MYSQL_HOST     = ENV.fetch('MYSQL_HOST', 'localhost')
MYSQL_PORT     = ENV.fetch('MYSQL_PORT', '3306')
MYSQL_DATABASE = ENV.fetch('MYSQL_DATABASE')
BACKUP_DIR     = ENV.fetch('BACKUP_DIR', './backups')

##
# Lambda function runs script
#
def script(event:, context:)
  log :debug, 'starting'

  start = Time.now.in_time_zone(TIMEZONE).beginning_of_day
  script_start = Time.now.in_time_zone(TIMEZONE)

  timestamp    = Time.now.utc.strftime('%Y%m%d-%H%M%S')
  filename     = "#{MYSQL_DATABASE}_backup_#{timestamp}.sql"
  backup_file  = File.join(BACKUP_DIR, filename)

  FileUtils.mkdir_p(BACKUP_DIR)

  ##
  # Construct mysqldump command
  #
  cmd = [
    'mysqldump',
    '--protocol=TCP',
    "-u #{MYSQL_USER}",
    "-p#{MYSQL_PASS}",
    "-h #{MYSQL_HOST}",
    "-P #{MYSQL_PORT}",
    MYSQL_DATABASE
  ].join(' ') + " > #{backup_file}"

  log :debug, 'Running backup...'
  stdout, stderr, status = Open3.capture3(cmd)

  if status.success?
    log :debug, "Backup completed: #{filename}"
  else
    log :fatal, "Backup failed with exit code #{status.exitstatus}"
    log :fatal, "STDOUT: #{stdout.strip}" unless stdout.strip.empty?
    log :fatal, "STDERR: #{stderr.strip}" unless stderr.strip.empty?

    raise StandardError, "mysqldump failed: #{stderr.strip}"
  end

  ##
  # gzip the file
  #
  gzip_file(backup_file, "#{backup_file}.gz")

  ##
  # Upload to S3
  #
  upload_to_s3("#{backup_file}.gz")

  ##
  # flushes the backup dir
  #
  flush(BACKUP_DIR)

  log :info, "finished, #{Time.now.in_time_zone(TIMEZONE) - script_start}"
rescue StandardError => e
  log :fatal, e.message
  e.backtrace.each { |line| log :fatal, "- #{line}" }
end
