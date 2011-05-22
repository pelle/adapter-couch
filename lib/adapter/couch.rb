require 'adapter'
require 'couchrest'

module Adapter
  module Couch
    NonHashValueKeyName = 'nh_value'

    def read(key)
      begin
        if doc = client.get(key_for(key))
          rev_map[key_for(key)] = doc.delete("_rev")
          decode(doc)
        end
      rescue RestClient::ResourceNotFound => e
        nil
      end
    end

    def write(key, value)
      doc = {"_id" => key_for(key)}.merge(encode(value))
      doc["_rev"] = rev_map[key_for(key)] if rev_map[key_for(key)]
      status = client.save_doc(doc)
      rev_map[key_for(key)] = status["rev"]
      value
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
    
    private
      
      # we want to hide couchdb's concept of revs behind the scenes. 
      # This is probably not the best way of doing it and we should clear it out after each request like
      # ToyStore's identity map
      def rev_map
        Thread.current[:couch_adapter_rev_map] ||= {}
      end

  end
end

Adapter.define(:couch, Adapter::Couch)