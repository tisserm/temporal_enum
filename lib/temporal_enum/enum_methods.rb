# frozen_string_literal: true

module TemporalEnum
  # Module that will be injected in ActiveRecord::Enum::EnumMethods
  module EnumMethods
    define_enum_methods_params = case ::ActiveRecord.version.version.to_f
                                 when (7.0...7.1) then "name, value_method_name, value, scopes"
                                 when (7.1..) then "name, value_method_name, value, scopes, instance_methods"
                                 else raise ActiveRecordVersionNotSupported
                                 end

    class_eval <<-CODE, __FILE__, __LINE__ + 1
      def define_enum_methods(#{define_enum_methods_params})
        define_temporal_methods(name, value_method_name, value, scopes) if TemporalEnum.enum_options.dig(name, :temporal)

        super
      end
    CODE

    private

    def define_temporal_methods(name, value_method_name, value, scopes)
      # def before_active?() status_before_type_cast < 0 end
      @klass.send(:detect_enum_conflict!, name, "before_#{value_method_name}?")
      define_method("before_#{value_method_name}?") { public_send("#{name}_before_type_cast") < value }

      # def after_active?() status_before_type_cast > 0 end
      @klass.send(:detect_enum_conflict!, name, "after_#{value_method_name}?")
      define_method("after_#{value_method_name}?") { public_send("#{name}_before_type_cast") > value }

      return unless scopes

      # scope :before_active, -> { where(status: ...0) }
      @klass.send(:detect_enum_conflict!, name, "before_#{value_method_name}", true)
      @klass.scope "before_#{value_method_name}", -> { where(name => ...value) }

      # scope :after_active, -> { where.not(status: ..0) }
      @klass.send(:detect_enum_conflict!, name, "after_#{value_method_name}", true)
      @klass.scope "after_#{value_method_name}", -> { where.not(name => ..value) }

      nil
    end
  end
end
