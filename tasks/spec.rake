gem 'rspec', '~>1.2.8'

require 'spec'
require 'spec/rake/spectask'

namespace :spec do
  
  namespace :ruby do
    desc 'run api specs through the Ruby implementations'
    task :api do
      puts "Ruby 1.8.7"
      puts `rake spec:api`
      puts "Ruby 1.9"
      puts `rake1.9 spec:api`
      puts "JRuby"
      puts `jruby -S rake spec:api`
    end
  end
  
  desc 'run api specs (mock out Solr dependency)'
  Spec::Rake::SpecTask.new(:api) do |t|
    
    t.spec_files = [File.join('spec', 'spec_helper.rb')]
    t.spec_files += FileList[File.join('spec', 'api', '**', '*_spec.rb')]
    
    # keeping this out so runcoderun is happy
    t.spec_files -= ['spec/api/connection/curb_spec.rb']
    
    unless defined? JRUBY_VERSION
      t.rcov = true
      t.rcov_opts = ['--exclude', 'spec', '--exclude', 'lib/rsolr/connection/direct']
    end
    
    t.verbose = true
    t.spec_opts = ['--color']
  end
  
  desc 'run integration specs'
  Spec::Rake::SpecTask.new(:integration) do |t|
    
    t.spec_files = [File.join('spec', 'spec_helper.rb')]
    t.spec_files += FileList[File.join('spec', 'integration', '**', '*_spec.rb')]
    
    unless defined? JRUBY_VERSION
      t.rcov = true
      t.rcov_opts = ['--exclude', 'spec', '--exclude', 'lib/rsolr/connection/direct']
    end
    
    t.verbose = true
    t.spec_opts = ['--color']
  end
  
end