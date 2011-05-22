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
    doc = adapter.write('foo', 'steak' => 'bacon')
    client.get('foo').should == {'_id' => 'foo', '_rev' => doc['rev'], 'steak' => 'bacon'}
  end

end