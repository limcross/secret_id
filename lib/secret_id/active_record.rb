module SecretId
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      # Override ActiveRecord::FinderMethods#find_with_ids decoding ids
      def find_with_ids(*ids)
        return super(*ids) unless @klass.is_a?(SecretId)

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
end
