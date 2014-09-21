module Houston::Alerts
  class Configuration
    
    def initialize
      @workers_proc = Proc.new { User.developers.unretired }
      @default_worker_for_proc = Proc.new { |alert| nil }
      config = Houston.config.module(:alerts).config
      instance_eval(&config) if config
    end
    
    def workers(*args, &block)
      if block
        @workers_proc = block
      else
        @workers_proc.call(*args)
      end
    end
    
    def default_worker_for(*args, &block)
      if block
        @default_worker_for_proc = block
      else
        @default_worker_for_proc.call(*args)
      end
    end
    
  end
end
