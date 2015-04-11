require 'uri'

module Cinch
    class Rubydoc
        include Cinch::Plugin
        BASE_URL = 'http://www.rubydoc.info/stdlib/core/'

        match /ri (\w+)([#.]\w+)?/

        def execute(m, klass, method = nil)
            url = URI.join(Rubydoc::BASE_URL, klass)

            $stderr.puts method
            if method.nil?
                # noop
            elsif method.start_with?('.')
                # Class method
                url.merge!("##{method[1..-1]}-class_method")
            else
                # Instance method
                url.merge!("##{method[1..-1]}-instance_method")
            end

            m.reply url.to_s
        end
    end
end
