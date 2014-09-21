module Houston::Alerts
  class Configuration
    
    def initialize
      @workers_proc = Proc.new { User.developers.unretired }
      config = Houston.config.module(:alerts).config
      instance_eval(&config) if config
    end
    
    def workers(&block)
      if block
        @workers_proc = block
      else
        @workers_proc.call
      end
    end
    
  end
end
