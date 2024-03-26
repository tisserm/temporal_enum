# frozen_string_literal: true

module TemporalEnum
  # Module that will be injected in ActiveRecord::Enum
  module Enum
    def enum(name = nil, values = nil, **options)
      TemporalEnum.enum_options[name] = options

      super
    end
  end
end
