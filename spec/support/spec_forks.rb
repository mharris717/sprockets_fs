class SpecForks
  class << self
    fattr(:instance) { new }
    def method_missing(sym,*args,&b)
      instance.send(sym,*args,&b)
    end
  end

  fattr(:commands) { [] }
  fattr(:pids) { {} }
  def add(cmd)
    #puts "adding #{cmd}"
    self.commands << cmd
  end

  def start!
    commands.uniq.each do |cmd|
      Bundler.with_clean_env do
        pids[cmd] = fork { exec cmd }
      end
      sleep(0.1)
    end
  end

  def kill!
    #puts "killing"
    pids.values.each do |pid|
      ec "pkill -TERM -P #{pid}", :silent => true
    end
  end
end

shared_context "fork" do
  let(:forks) do
    res = SpecForks.new 
    [cmds].flatten.each { |x| res.add(x) }
    res
  end
  before(:all) do
    forks.start!
  end
  after(:all) do
    forks.kill!
  end
end