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
            begin
              id = decode_id(ids.first)
            rescue
              raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with secret id=#{ids.first}"
            end

            result = find_one(id)
            expects_array ? [ result ] : result
          else
            ids.map! do |id|
              begin
                decode_id(id)
              rescue
                raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with secret id=#{id}"
              end
            end

            find_some(ids)
          end
        rescue RangeError
          raise ::ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with an out of range ID"
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

            return super ids, secret_id: false if options[:secret_id] === false
            return super if ids.first.kind_of?(Array)
          end

          ids.map! do |id|
            begin
              decode_id(id)
            rescue
              raise ::ActiveRecord::RecordNotFound, "Couldn't find #{self.name} with secret id=#{id}"
            end
          end

          return super ids, secret_id: false
        end
      end
    end
  end
end
