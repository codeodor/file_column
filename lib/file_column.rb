# plugin init file for rails
# this file will be picked up by rails automatically and
# add the file_column extensions to rails

require_relative 'file_column/file_column'
require_relative 'file_column/file_compat'
require_relative 'file_column/file_column_helper'
require_relative 'file_column/validations'
require_relative 'file_column/railtie'
