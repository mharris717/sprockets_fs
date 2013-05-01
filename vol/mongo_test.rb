require 'rubygems'
require 'mongo'
require 'mharris_ext'

class MongoLog

  fattr(:db) do
    Mongo::Connection.new("192.168.1.109").db('mongo_log')
  end
  fattr(:coll) do
    db.collection('entries')
  end

  def make(ops)
    coll.save(ops)
  end

  class << self
    fattr(:instance) { new }
  end
end


puts MongoLog.new.coll.count