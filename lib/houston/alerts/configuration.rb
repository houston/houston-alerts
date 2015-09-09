module Houston::Alerts
  class Configuration

    def initialize
      @workers_proc = Proc.new { User.developers.unretired }
    end

    def workers(*args, &block)
      if block
        @workers_proc = block
      else
        @workers_proc.call(*args)
      end
    end

    def sync(mode, name, options={})
      Houston.config.every options.fetch(:every), "alerts:sync:#{name}", options do
        Houston::Alerts::Alert.synchronize(mode, name, yield)
      end
    end

  end
end
