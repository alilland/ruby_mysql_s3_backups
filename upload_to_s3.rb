# frozen_string_literal: true

require_relative './settings'

BUCKET_NAME = ENV.fetch('S3_BUCKET')
REGION = ENV.fetch('S3_REGION')
TIMEZONE = ENV.fetch('TIMEZONE')

def upload_to_s3(backup_file)
  client = Aws::S3::Client.new(region: REGION)
  s3 = Aws::S3::Resource.new(client: client)

  bucket = s3.bucket(BUCKET_NAME)

  log :debug, "successfully connected to s3 #{BUCKET_NAME}"

  puts backup_file
end
