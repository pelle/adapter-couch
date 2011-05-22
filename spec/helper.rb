$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

require 'pathname'
require 'logger'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
log_path  = root_path.join('log')
log_path.mkpath

require 'adapter/spec/an_adapter'
require 'adapter/spec/types'

require 'adapter-couch'

shared_examples_for "a couch adapter" do
  it_should_behave_like 'an adapter'

  Adapter::Spec::Types.each do |type, (key, key2)|
    it "writes Object values to keys that are #{type}s like a Hash" do
      v = adapter.write(key, {:foo => :bar})
      # couch knows hashes
      adapter[key].should == {'_id' => 'key', 'foo' => 'bar', '_rev' => v['rev']}
    end
  end
end

logger = Logger.new(log_path.join('test.log'))
LogBuddy.init(:logger => logger)

Rspec.configure do |c|

end
