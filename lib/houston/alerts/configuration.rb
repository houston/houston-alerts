module Houston::Alerts
  class Configuration

    def initialize
      @workers_proc = Proc.new { User.developers.unretired }
      @set_deadline_proc = Proc.new { |alert| 2.days.after alert.opened_at }
    end

    def workers(*args, &block)
      if block
        @workers_proc = block
      else
        @workers_proc.call(*args)
      end
    end

    def set_deadline(*args, &block)
      if block
        @set_deadline_proc = block
      else
        @set_deadline_proc.call(*args)
      end
    end

    def sync(mode, name, options={})
      Houston.config.every options.fetch(:every), "alerts:sync:#{name}", options do
        Houston::Alerts::Alert.synchronize(mode, name, yield)
      end
    end

  end
end
