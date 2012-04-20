module RequirejsBuild

  class Build

    attr_accessor :steps

    def initialize(*args)
      @steps = args.inject({}) { |m, s| m[s.name] = s.new; m }
    end

    def run
      @steps.each { |s| s.last.perform }
    end

    def step(name)
      @steps[name]
    end

  end

end
