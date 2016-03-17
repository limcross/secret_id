require 'active_support/concern'
require 'secret_id/version'

module SecretId
  autoload :Base,         'secret_id/base'
  autoload :ActiveRecord, 'secret_id/active_record'

  def self.extended(base)
    base.include SecretId::Base

    if defined?(::ActiveRecord::Base)
      ::ActiveRecord::Relation.include SecretId::ActiveRecord
    end

    super
  end

  begin
    require 'hashids'
  rescue LoadError
  end
end
