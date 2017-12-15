# Frozen-string-literal: true
# Copyright: Since 2017 Tamanguu GmbH & Co KG - MIT License
# Encoding: utf-8

# Public tasks

task :default => :build

# Build the gem
task :build => [:test] do
  sh "bundle exec gem build jekyll-category-pages.gemspec"
end

# Run Jekyll in the example directory
task :example => [:install] do
  sh "cd example; bundle exec jekyll build"
end

# Run all tests
task :test => [:install] do
  sh "cd spec/test; bundle exec jekyll build --config _config1.yml"
  sh "cd spec/test; bundle exec jekyll build --config _config2.yml"
  sh "bundle exec rspec"
end

# Clean up all transient files
task :clean do
  sh "bundle clean"
  sh "rm -r Gemfile.lock example/_site example/.sass_cache spec/test/_site1 spec/test/_site2"
end

# Private helpers

# Make sure all dependencies are installed
task :install do
  sh "bundle install"
end
