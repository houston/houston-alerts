require "set"

module Houston::Alerts
  class Configuration

    def initialize
      @workers_proc = Proc.new { ::User.developers.unretired }
      @set_deadline_proc = Proc.new { |alert| 2.days.after alert.opened_at }
      @types = Set.new
      @icons_by_type = {}
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

    def types
      @types.to_a
    end

    def icons_by_type
      @icons_by_type
    end

    def sync(mode, name, options={})
      @types.add name
      @icons_by_type[name] = options.fetch(:icon)
      Houston.config.every options.fetch(:every), "alerts:sync:#{name}" do
        Houston::Alerts::Alert.synchronize(mode, name, yield)
      end
    end

    def sounds(&block)
      @sounds ||= {}
      SoundConfigDsl.new(@sounds).instance_eval(&block) if block_given?
      @sounds
    end

  private

    class SoundConfigDsl
      def initialize(hash)
        @hash = hash
      end

      def new_alert(*sounds)
        @hash[:new] = sounds
      end

      def no_alerts(*sounds)
        @hash[:none] = sounds
      end
    end

  end
end
