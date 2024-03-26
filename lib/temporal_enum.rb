# frozen_string_literal: true

require "active_record"
require_relative "temporal_enum/version"
require_relative "temporal_enum/enum"
require_relative "temporal_enum/enum_methods"

# Override ActiveRecord' Enum to add methods and scopes
module TemporalEnum
  def self.enum_options
    @enum_options ||= HashWithIndifferentAccess.new
  end

  ActiveRecord::Enum.prepend(TemporalEnum::Enum)
  ActiveRecord::Enum.const_get(:EnumMethods).prepend(TemporalEnum::EnumMethods)

  class ActiveRecordVersionNotSupported < StandardError; end
end
