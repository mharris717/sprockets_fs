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
    puts "adding #{cmd}"
    self.commands << cmd
  end

  def start!
    commands.uniq.each do |cmd|
      pids[cmd] = fork { exec cmd }
      sleep(0.1)
    end
  end

  def kill!
    pids.values.each do |pid|
      ec "kill #{pid}"
    end
  end
end