Gem::Specification.new do |s|
    s.name = 'cinch-rubydoc'
    s.version = '0.1.0'
    s.license = 'MIT'
    s.summary = %q(A ruby doc matcher for Cinch)
    s.description = %q(This provides a Cinch plugin to give ruby doc links for doc requests)
    s.authors = [ %q(Thibault `Adædra` Hamel) ]
    s.email = %w[me@adaedra.eu]
    s.files = %w[lib/cinch/rubydoc.rb]
    s.homepage = 'https://github.com/adaedra/cinch-rubydoc'

    s.add_runtime_dependency 'cinch', '~> 2.2'
end
