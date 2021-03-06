module SecretId
  module ActiveRecord
    module FinderMethods
      extend ActiveSupport::Concern

      included do
        # Override ActiveRecord::FinderMethods#find_with_ids decoding ids
        def find_with_ids(*ids)
          return super unless @klass.is_a?(SecretId)

          unless ids.length == 1
            options = ids.slice!(ids.size - 1) if ids.last.kind_of?(Hash)
            options ||= {}
            return super if options[:secret_id] === false
          end

          raise UnknownPrimaryKey.new(@klass) if primary_key.nil?

          expects_array = ids.first.kind_of?(Array)
          return ids.first if expects_array && ids.first.empty?

          ids = ids.flatten.compact.uniq

          case ids.size
          when 0
            raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} without an ID"
          when 1
            result = find_one(decode_id(ids.first))
            expects_array ? [ result ] : result
          else
            find_some(ids.map { |id| decode_id(id) })
          end
        rescue RangeError
          raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with an out of range ID"
        rescue SecretId::NotDecodable
          raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with secret id (could not be decoded)"
        end
      end
    end

    module Core
      extend ActiveSupport::Concern

      module ClassMethods
        # Override ActiveRecord::Core#find decoding ids, if is necessary
        def find(*ids)
          if ids.length == 1
            return super if ids.first.kind_of?(Array)
          else
            options = ids.slice!(ids.size - 1) if ids.last.kind_of?(Hash)
            options ||= {}
            return super(*ids, secret_id: false) if options[:secret_id] === false
          end

          ids = ids.map { |id| decode_id(id) }
          ids = ids.first if ids.length == 1

          return super(*ids, secret_id: false)
        rescue SecretId::NotDecodable
          raise ::ActiveRecord::RecordNotFound, "Couldn't find #{self.name} with secret id (could not be decoded)"
        end
      end
    end
  end
end
