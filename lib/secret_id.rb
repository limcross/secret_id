require 'hashids'
require 'active_support/concern'

require 'secret_id/version'
require 'secret_id/errors'

module SecretId
  autoload :Base,         'secret_id/base'
  autoload :ActiveRecord, 'secret_id/active_record'

  def self.extended(base)
    base.include SecretId::Base

    if defined?(::ActiveRecord::Base)
      base.include SecretId::ActiveRecord::Core
      ::ActiveRecord::Relation.include SecretId::ActiveRecord::FinderMethods
    end

    super
  end
end
