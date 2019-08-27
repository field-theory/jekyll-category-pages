# frozen_string_literal: true
# Copyright: Since 2017 Tamanguu GmbH & Co KG - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gemspec

group :example do
  gem "rake"
  gem "jekyll", ">= 4.0"
  gem "minima", "~> 2.0"

  group :jekyll_plugins do
  #  gem "jekyll-category-pages" # Not needed for current gem
    gem "jekyll-paginate"
  end

  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
end
