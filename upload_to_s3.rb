# frozen_string_literal: true

require 'aws-sdk-s3'
require_relative './settings'

BUCKET_NAME = ENV.fetch('S3_BUCKET')
REGION      = ENV.fetch('S3_REGION')
TIMEZONE    = ENV.fetch('TIMEZONE')

def upload_to_s3(backup_file)
  log :debug, "Preparing to upload #{backup_file} to S3..."

  client = Aws::S3::Client.new(region: REGION)
  s3     = Aws::S3::Resource.new(client: client)
  bucket = s3.bucket(BUCKET_NAME)

  unless bucket.exists?
    raise "S3 bucket '#{BUCKET_NAME}' does not exist"
  end

  key = File.basename(backup_file)
  obj = bucket.object(key)

  obj.upload_file(
    backup_file,
    content_type: 'application/sql',
    acl: 'private'
  )

  log :info, "Successfully uploaded #{key} to S3 bucket #{BUCKET_NAME}"
rescue Aws::S3::Errors::ServiceError => e
  log :fatal, "Failed to upload to S3: #{e.message}"
  raise
end
