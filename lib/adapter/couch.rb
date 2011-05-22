require 'adapter'
require 'couchrest'

module Adapter
  module Couch
    NonHashValueKeyName = 'nh_value'

    def read(key)
      begin
        if doc = client.get(key_for(key))
          decode(doc)
        end
      rescue RestClient::ResourceNotFound => e
        nil
      end
    end

    def write(key, value)
      doc = client.save_doc({"_id" => key_for(key)}.merge(encode(value)))
      doc
    end

    def delete(key)
      begin
        doc = client.get(key_for(key))
        client.delete_doc(doc)
        decode(doc)
      rescue RestClient::ResourceNotFound => e
        nil
      end        
    end

    def clear
      client.recreate!
    end

    def encode(value)
      value.is_a?(Hash) ? value : {NonHashValueKeyName => value}
    end

    def decode(value)
      return if value.nil?
      value.key?(NonHashValueKeyName) ? value[NonHashValueKeyName] : value
    end

  end
end

Adapter.define(:couch, Adapter::Couch)