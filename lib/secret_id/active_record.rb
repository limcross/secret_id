module SecretId
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      # Override ActiveRecord::FinderMethods#find_with_ids decoding ids
      def find_with_ids(*ids)
        raise UnknownPrimaryKey.new(@klass) if primary_key.nil?

        expects_array = ids.first.kind_of?(Array)
        return ids.first if expects_array && ids.first.empty?

        ids = ids.flatten.compact.uniq

        case ids.size
        when 0
          raise RecordNotFound, "Couldn't find #{@klass.name} without an ID"
        when 1
          result = find_one(decode_id(ids.first))
          expects_array ? [ result ] : result
        else
          find_some(ids.map {|id| decode_id(id)})
        end
      rescue RangeError
        raise RecordNotFound, "Couldn't find #{@klass.name} with an out of range ID"
      end
    end
  end
end
