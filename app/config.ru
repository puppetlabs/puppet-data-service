# Enable easy use of `require` for content in lib/
libdir = File.expand_path(File.join(__dir__, 'lib'))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require './app'
run App
