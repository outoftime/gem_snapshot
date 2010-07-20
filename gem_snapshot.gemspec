Gem::Specification.new do |spec|
  spec.name = 'gem_snapshot'
  spec.version = Gem::Version.new('0.0.1')
  spec.files = Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'))
  spec.summary = 'Dump and restore snapshot of installed gems.'
  spec.description = <<-DESC
Gem plugin that provides two new rubygems commands, `gem snapshot dump' and
`gem snapshot restore'. The `dump' command outputs a manifest of installed gems
in YAML (either to a file or STDOUT), and the `restore' command reads a dump and
installs all gems that aren't already installed.
DESC
  spec.author = 'Mat Brown'
  spec.email = 'mat@patch.com'
  spec.rubyforge_project = 'gem_snapshot'
  spec.has_rdoc = false
end
