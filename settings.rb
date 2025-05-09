# frozen_string_literal: true

require 'aws-sdk-s3'
require 'active_support/time'
require 'date'
require 'dotenv'
require 'fileutils'
require 'time'
require 'open3'
require 'zlib'

Dotenv.load

require_relative './log'
require_relative './gzip_file'
require_relative './upload_to_s3'
require_relative './flush'
