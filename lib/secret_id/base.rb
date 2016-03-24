module SecretId
  module Base
    extend ActiveSupport::Concern

    included do
      class_attribute :hashids

      def to_param
        secret_id
      end

      def secret_id
        self.class.encode_id(id) unless id.nil?
      end
    end

    module ClassMethods
      def secret_id(options = {})
        options = default_options.merge(options)

        self.hashids = Hashids.new(
          options[:salt],
          options[:min_length],
          options[:alphabet]
        )
      end

      def decode_id(hashed_id)
        self.hashids.decode(hashed_id).first
      rescue
        raise SecretId::NotDecodable, 'could not be decoded'
      end

      def encode_id(id)
        self.hashids.encode(id)
      end

    private

      def default_options
        {
          salt: name,
          min_length: 3,
          alphabet: Hashids::DEFAULT_ALPHABET
        }
      end
    end
  end
end
