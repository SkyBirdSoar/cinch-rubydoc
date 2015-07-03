require 'uri'
require 'pry'
require 'pry-byebug'

module Cinch
    class Rubydoc
        include Cinch::Plugin
        BASE_URL = 'https://devdocs.io/ruby/'
        UNSAFE_CHARS = /[^0-9a-zA-Z\$_\.\+!\*'\(\)-]/

        match /ri ([\w:-]+)([#.][^:\s]+)?$/

        def execute(m, klass, method = nil)
            real_klass = find_class klass
            if real_klass.nil?
                m.reply "I'm sorry, I don't know anything about #{klass}."
                return
            end

            type = nil
            real_method = nil
            unless method.nil?
                type = method.slice!(0) == '#' ? :instance : :class
                real_method = find_method(real_klass, method.to_sym, type)

                if real_method.nil?
                    m.reply "I'm sorry, I found no #{type} method named #{method} in #{real_klass.name}"
                    return
                end

                real_klass = real_method.owner
                real_klass = real_method.receiver if real_method.owner.name.nil?
            end

            klass_path = real_klass.name.split('::').map { |n| URI.encode(n, UNSAFE_CHARS).downcase }.join('/')
            url = URI.join(Rubydoc::BASE_URL, klass_path)

            unless real_method.nil?
                url.merge!("#method-#{type.to_s[0]}-#{URI.encode(method, UNSAFE_CHARS).gsub(/%/, '-')}")
            end

            m.reply url.to_s
        end

        def find_class(klass)
            klass_path = klass.split('::')
            current = Object

            klass_path.each do |e|
                current = current.const_get(e.to_sym)
            end

            current
        rescue NameError
            nil
        end

        def find_method(klass, method, type)
            if type == :class
                klass.method method
            else
                klass.instance_method method
            end
        rescue NameError
            nil
        end
    end
end
