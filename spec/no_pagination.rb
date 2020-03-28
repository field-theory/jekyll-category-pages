# Frozen-string-literal: true
# Copyright: Since 2017 Wolfram Schroers - MIT License
# Encoding: utf-8

require 'jekyll-category-pages'

basedir = 'spec/test/_site1/category/'
jekyll = basedir + 'jekyll/'
haodezhuyi = basedir + '好的主意/'
plugin = basedir + 'category-pages-plugin/'
books_publications = basedir + 'books-publications/'
great_greater = basedir + 'great-greater/'
index = 'index.html'

describe Jekyll::CategoryPages do
  context "no_pagination" do
    it "category indices exists" do
      expect(File.file? jekyll+index).to be true
      expect(File.file? haodezhuyi+index).to be true
      expect(File.file? plugin+index).to be true
      expect(File.file? books_publications+index).to be true
      expect(File.file? great_greater+index).to be true
    end

    it "category jekyll is correct" do
      load jekyll+index
      expect($page_title).to eql('jekyll')
      expect($page_category).to eql('jekyll')
      expect($page_total_posts).to eql(5)
      expect($page_posts_title).to eql([ "More about Jekyll", "Everything you always wanted to know about Jekyll",
                                         "About the plugin", "Welcome to the plugin", "Welcome to Jekyll!" ])
      expect($page_posts_url).to eql(%w(/2017/12/13/more-about-jekyll.html /2017/12/13/everything-you-ever.html /2017/12/13/about-the-plugin.html /2017/12/13/welcome-to-the-plugin.html /2017/12/13/welcome-to-jekyll.html))
    end

    it "category 好的主意 is correct" do
      load haodezhuyi+index
      expect($page_title).to eql('好的主意')
      expect($page_category).to eql('好的主意')
      expect($page_total_posts).to eql(1)
      expect($page_posts_title).to eql([ "Welcome to the plugin" ])
      expect($page_posts_url).to eql([ "/2017/12/13/welcome-to-the-plugin.html" ])
    end

    it "category Category Pages Plugin is correct" do
      load plugin+index
      expect($page_title).to eql('Category Pages Plugin')
      expect($page_category).to eql('Category Pages Plugin')
      expect($page_total_posts).to eql(2)
      expect($page_posts_title).to eql([ "About the plugin", "Welcome to the plugin" ])
      expect($page_posts_url).to eql(%w(/2017/12/13/about-the-plugin.html /2017/12/13/welcome-to-the-plugin.html))
    end

    it "category Books & Publications are correct" do
      load books_publications+index
      expect($page_title).to eql('Books & Publications')
      expect($page_category).to eql('Books & Publications')
      expect($page_total_posts).to eql(1)
      expect($page_posts_title).to eql([ "HTML entities in categories" ])
      expect($page_posts_url).to eql([ "/2019/01/06/html-entities-in-categories.html" ])
    end

    it "category Great < & Greater are correct" do
      load great_greater+index
      expect($page_title).to eql('Great < & Greater')
      expect($page_category).to eql('Great < & Greater')
      expect($page_total_posts).to eql(1)
      expect($page_posts_title).to eql([ "HTML entities in categories" ])
      expect($page_posts_url).to eql([ "/2019/01/06/html-entities-in-categories.html" ])
    end  end
end
