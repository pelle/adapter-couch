require 'helper'
require 'couchrest'

describe "Couch adapter" do
  before do
    @client = CouchRest.database!("http://127.0.0.1:5984/adapter-couch-test")
    @adapter = Adapter[:couch].new(@client)
    @adapter.clear
  end

  let(:adapter) { @adapter }
  let(:client)  { @client }

  it_should_behave_like 'a couch adapter'

  it "stores hashes right in document" do
    adapter.write('foo', 'steak' => 'bacon')
    client.get('foo').should == {'_id' => 'foo', '_rev' => adapter.send(:rev_map)['foo'], 'steak' => 'bacon'}
  end
  
  it "should save with rev" do
    adapter.write('foo', 'steak' => 'bacon')
    lambda { adapter.write('foo', 'steak' => 'ham')}.should_not raise_error(RestClient::Conflict)
  end
  
  it "should load existing and save" do
    client.save_doc("_id"=>"foo", "steak" => "bacon")
    doc = adapter.get('foo')
    lambda { adapter.write('foo', 'steak' => 'ham')}.should_not raise_error(RestClient::Conflict)
  end
end