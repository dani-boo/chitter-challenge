require 'pg'
require './lib/connect_database'

class Peep
  attr_reader :id, :username, :peep, :created_at

  def initialize(id, username, peep, created_at)
    @id = id
    @username = username
    @peep = peep
    @created_at = created_at
  end

  def self.all
    result = ConnectDatabase.query('SELECT * FROM peeps')
    result.map { |peep| Peep.new(peep['id'], peep['username'],
                  peep['peep'], peep['created_at']) }
  end
   
  def self.create(options)
    result = ConnectDatabase.query("INSERT INTO peeps (username, peep) 
      VALUES('#{options[:username]}', '#{options[:peep]}') 
      RETURNING id, username, peep, created_at")
    Peep.new(result[0]['id'], result[0]['username'],
      result[0]['peep'], result[0]['created_at'])
  end

  def ==(match)
    @id == match.id
  end
end
