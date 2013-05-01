#require 'mongo'
require 'mharris_ext'

module LogMethods
  def calling_lines
    raise 'foo'
  rescue => exp
    base = test = other = nil
    dir = File.expand_path(File.dirname(__FILE__) + "/../..")

    File.append "traces.txt", exp.backtrace.join("\n") + "\n\n\n"

    exp.backtrace[3..-1].each do |line|
      if line =~ /rspec-core/
        # do nothing
      elsif line.starts_with?(dir)
        short = line.gsub("#{dir}/","")
        if short.starts_with? "lib"
          base ||= short
        elsif short.starts_with? "spec"
          test ||= short
        else
          raise "unknown #{line} | #{short}"
        end
      elsif line =~ /fattr/ || line.starts_with?("(eval):")
        # do nothing
      else
        other ||= line
      end
      if base && test && other
        test = "#{test} #{get_spec_name(test)}"
        return [base,test,other]
      end
    end
    return [base,test,other] if base && test
    raise 'end'
  end

  def get_spec_name(desc)
    file,line,junk = *desc.split(" ").first.split(":")
    lines = File.read(file).split("\n")[0...(line.to_i)].reverse
    lines.each do |line|
      if line =~ /it\s+['"]([a-z _0-9]+)['"]\s+do/
        return $1
      end
    end
    raise 'no spec name'
  end

  def get_fattr_name(desc)
    file,line,junk = *desc.split(" ").first.split(":")
    lines = File.read(file).split("\n")[0...(line.to_i)].reverse
    lines.each do |line|
      if line =~ /fattr\(:([a-z0-9_]+)\)\s+do/
        return $1
      end
    end
    raise 'no fattr name'
  end



  def log_special(obj,&b)
    dt = Time.now

    lines = calling_lines
    line = lines.join(" | ")

    raise "bad line, cant find calling function #{lines.first}" unless lines.first =~ /in `([a-z0-9_ <>:]+)'/i
    caller = $1

    if caller.starts_with?("block in <")
      caller = get_fattr_name(lines.first) 
    elsif caller.starts_with?("block in")
      raise "bad line, cant find calling function #{caller}" unless caller =~ /block in ([a-z0-9_!]+)/i
      caller = $1
    end

    library = nil
    if lines.last
      if  lines.last =~ /in `([a-z0-9_ <>:]+)'/i
        library = $1
      end
    end

    res = nil
    message = obj.inspect
    if block_given?
      res = yield
      message += " RES: #{res.inspect}"
    end
    
    make :dt => dt, :base_line => lines.first, :spec_line => lines[1], :spec => get_spec_name(lines[1]), :message => message, :caller => caller, :library => library, :library_line => lines.last

    File.append "log_special.log","#{dt} from #{line}\n#{obj.inspect}\n\n"

    res
  end
end

class Time
  def short
    t = self - 60*60*4
    t.strftime "%H:%M:%S:%L"
  end
end

class MongoLog
  include LogMethods
  fattr(:db) do
    Mongo::Connection.new.db('mongo_log')
  end
  fattr(:coll) do
    db.collection('entries')
  end
  def rows(ops={})
    coll.find(ops).map { |x| LogRow.new(x) }.sort
  end

  def make(ops)
    coll.save(ops)
  end

  class << self
    fattr(:instance) { new }
    def log(obj='',&b)
      return yield if block_given?
      return
      instance.log_special(obj,&b)
    end
  end
end

ML = MongoLog

class LogRow
  include FromHash
  attr_accessor :dt, :base_line, :spec_line, :spec, :message, :caller, :_id, :library_line, :library

  def to_ss
    c = [caller,library].select { |x| x }.join(" ").rpad(25)
    "#{dt.short} From #{c} | #{spec.rpad(20)}: #{message[0...18000]}"
  end

  def <=>(r)
    dt <=> r.dt
  end
end

def get_opt_args
  require 'optparse'

  options = {}
  OptionParser.new do |opts|
    opts.on("-s","--s SPEC") do |v|
      v = /#{v[1..-1]}/i if v[0..0] == '/'
      options[:spec] = v
    end

    opts.on("-c","--c CALLER") do |v|
      v = /#{v[1..-1]}/i if v[0..0] == '/'
      options[:caller] = v
    end
  end.parse!

  puts "options #{options.inspect}"

  options
end

if __FILE__==$0
  m = MongoLog.instance
  puts m.coll.count
  arr = m.rows(get_opt_args)

  arr.each do |row|
    #puts "Row: " + row.inspect
  end

  arr.each do |row|
    puts row.to_ss
  end
end

