# Cinch::RubyDoc

Creates a RubyDoc plugin for a Cinch bot. The plugin reacts to the `ri` command and will provide links to rubydoc.info for the requested method, class, module or constant.

## Dependencies

Require Cinch (obviously) and yard.

You also need a local copy of YARD documentation for core and stdlib. You can generate it by running, at the root directory of ruby source directory:

    yardoc -n 'ext/**/*.c' 'lib/**/*.rb' *.c

This will create a `.yardoc` directory that you can copy to the working directory of your bot to be pikced up by the plugin.
