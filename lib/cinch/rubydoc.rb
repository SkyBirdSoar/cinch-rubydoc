require 'yard'
require 'cgi'


module Cinch
    class Rubydoc
        include Cinch::Plugin
        BASE_URL = 'http://www.rubydoc.info/stdlib'

        match /ri (.+)\z/

        def initialize(*args)
            super
            @store = YARD::RegistryStore.new
            @store.load '.yardoc'
        end

        def execute(m, request)
            requests = request.split /[ ,]+/
            if requests.count > 3
                requests = requests.first(3)
            end

            uris = requests.map do |request|
                url_for(request)
            end

            uris.compact!
            if uris.empty?
                m.reply 'No results'
            else
                m.reply uris.join ', '
            end
        end

        private

        def url_for(name)
            obj = @store[name]
            if obj.nil? && name.end_with?('.new')
                obj = @store[name.sub(/\.new\z/, '#initialize')]
            end

            unless obj
                debug "Nothing found for #{name}"
                return nil
            end

            section = section_for obj
            "#{BASE_URL}/#{section}/#{path_for obj}"
        end

        def section_for(obj)
            return :core if obj.files.any? { |f, _| !f.include?('/') }
            File.basename(obj.file.split('/', 3)[1], '.rb')
        end

        def path_for(obj)
            case obj.type
            when :method
                    "#{path_for obj.parent}##{CGI.escape obj.name.to_s}-#{obj.scope}_method"
            when :constant
                    "#{path_for obj.parent}##{obj.name}-constant"
            when :class, :module
                    obj.path.gsub('::', '/')
            end
        end
    end
end
