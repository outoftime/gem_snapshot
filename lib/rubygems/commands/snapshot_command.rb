require 'rubygems/install_update_options'
require 'yaml'

class Gem::Commands::SnapshotCommand < Gem::Command
  include Gem::InstallUpdateOptions

  def initialize
    super('snapshot', "Dump and restore snapshots of installed rubygems", :file => nil) 
    add_option '-f', '--file=FILE', 'Snapshot file (default is stdin/stdout)' do |f, options|
      options[:file] = f
    end
    add_install_update_options
  end

  def execute
    case options[:args].first
    when 'dump' then dump
    when 'restore' then restore
    else abort(usage)
    end
  end

  def arguments
    "ACTION          (dump|restore)"
  end

  def usage
    "#{program_name} ACTION"
  end

  def description
    <<TEXT
Allows you to easily dump a snapshot of all installed gems in an environment
and then restore the snapshot to installed gems.
TEXT
  end

  private

  def restore
    input =
      if options[:file] then File.open(options[:file], 'r')
      else STDIN
      end
    YAML.load(input).each_pair do |gem, versions|
      versions.each do |version|
        installed = Gem.source_index.find_name(gem, version)
        if installed.empty?
          puts "Installing #{gem} #{version}"
          installer = Gem::DependencyInstaller.new(options).install(gem, version)
        else
          puts "Already have #{gem} #{version}"
        end
      end
    end
    input.close
  end

  def dump
    out =
      if options[:file] then File.open(options[:file], 'w')
      else STDOUT
      end
    specs = Hash.new { |h, k| h[k] = [] }
    Gem.source_index.each do |name, specification|
      specs[specification.name] << specification.version.to_s
    end
    out.puts specs.to_yaml
    out.close
  end
end
