module Banshy
  class Logger
    include Singleton
    attr_reader :log
    def intialize
      @log = Logger.new(STDOUT)
      @log.level = Logger::WARN
    end
  end
end
