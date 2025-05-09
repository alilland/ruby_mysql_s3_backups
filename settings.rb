# frozen_string_literal: true

require 'aws-sdk-s3'
require 'active_support/time'
require 'date'
require 'dotenv'
require 'fileutils'
require 'time'
require 'open3'

Dotenv.load

require_relative './log'
