# frozen_string_literal: true
# Encoding: utf-8

#
# category_pages
# Add category index pages with and without pagination.
#
# (c) since 2017 by Wolfram Schroers
# Written by Dr. Wolfram Schroers <Wolfram.Schroers -at- field-theory.org>
#
# Copyright: Since 2017 Wolfram Schroers - MIT License
# See the accompanying file LICENSE for licensing conditions.
#

require 'jekyll'

module Jekyll
  module CategoryPages
    INDEXFILE = 'index.html'

    # Custom generator for generating all index pages based on a supplied layout.
    #
    # Note that this generator uses a layout instead of a regular page template, since
    # it will generate a set of new pages, not merely variations of a single page like
    # the blog index Paginator does.
    class Pagination < Generator
      # This generator is safe from arbitrary code execution.
      safe true
      priority :lowest

      # Generate paginated category pages if necessary.
      #
      # site - The Site object.
      def generate(site)
        category_base_path = site.config['category_path'] || 'category'
        category_layout_path = File.join('_layouts/', site.config['category_layout'] || 'category_index.html')

        if Paginate::Pager.pagination_enabled?(site)
          # Generate paginated category pages
          generate_paginated_categories(site, category_base_path, category_layout_path)
        else
          # Generate category pages without pagination
          generate_categories(site, category_base_path, category_layout_path)
        end
      end

      # Sort the list of categories and remove duplicates.
      #
      # site - The Site object.
      #
      # Returns an array of strings containing the site's categories.
      def sorted_categories(site)
        categories = []
        site.categories.each_pair do |category, pages|
          categories.push(category)
        end
        categories.sort!.uniq!
        return categories
      end

      # Generate the paginated category pages.
      #
      # site               - The Site object.
      # category_base_path - String with the base path to the category index pages.
      # category_layout    - The name of the basic category layout page.
      def generate_paginated_categories(site, category_base_path, category_layout)
        categories = sorted_categories site

        # Generate the pages
        for category in categories
          posts_in_category = site.categories[category]
          category_path = File.join(category_base_path, Utils.slugify(category))
          per_page = site.config['paginate']

          page_number = CategoryPager.calculate_pages(posts_in_category, per_page)
          page_paths = []
          category_pages = []
          (1..page_number).each do |current_page|
            # Collect all paths in the first pass and generate the basic page templates.
            page_name = current_page == 1 ? INDEXFILE : "page#{current_page}.html"
            page_paths.push page_name
            new_page = CategoryIndexPage.new(site, category_path, page_name, category, category_layout, posts_in_category, true)
            category_pages.push new_page
          end

          (1..page_number).each do |current_page|
            # Generate the paginator content in the second pass.
            previous_link = current_page == 1 ? nil : page_paths[current_page - 2]
            next_link = current_page == page_number ? nil : page_paths[current_page]
            previous_page = current_page == 1 ? nil : (current_page - 1)
            next_page = current_page == page_number ? nil : (current_page + 1)
            category_pages[current_page - 1].add_paginator_relations(current_page, per_page, page_number,
                                                                     previous_link, next_link, previous_page, next_page)
          end

          for page in category_pages
            # Finally, add the new pages to the site in the third pass.
            site.pages << page
          end
        end

        Jekyll.logger.debug("Paginated categories", "Processed " + categories.size.to_s + " paginated category index pages")
      end

      # Generate the non-paginated category pages.
      #
      # site               - The Site object.
      # category_base_path - String with the base path to the category index pages.
      # category_layout    - The name of the basic category layout page.
      def generate_categories(site, category_base_path, category_layout)
        categories = sorted_categories site

        # Generate the pages
        for category in categories
          posts_in_category = site.categories[category]
          category_path = File.join(category_base_path, Utils.slugify(category))

          site.pages << CategoryIndexPage.new(site, category_path, INDEXFILE, category, category_layout, posts_in_category, false)
        end

        Jekyll.logger.debug("Categories", "Processed " + categories.size.to_s + " category index pages")
      end

    end
  end

  # Auto-generated page for a category index.
  #
  # When pagination is enabled, contains a CategoryPager object as paginator. The posts in the
  # category are always available as posts, the total number of those is always total_posts.
  class CategoryIndexPage < Page
    # Attributes for Liquid templates.
    ATTRIBUTES_FOR_LIQUID = %w(
      category
      paginator
      posts
      total_posts
      content
      dir
      name
      path
      url
    )

    # Initialize a new category index page.
    #
    # site              - The Site object.
    # dir               - Base directory for all category pages.
    # page_name         - Name of this category page (either 'index.html' or 'page#.html').
    # category          - Current category as a String.
    # category_layout   - Name of the category index page layout (must reside in the '_layouts' directory).
    # posts_in_category - Array with full list of Posts in the current category.
    # use_paginator     - Whether a CategoryPager object shall be instantiated as 'paginator'.
    def initialize(site, dir, page_name, category, category_layout, posts_in_category, use_paginator)
      @site = site
      @base = site.source
      if ! File.exist?(File.join(@base, category_layout)) && 
        ( site.theme && File.exist?(File.join(site.theme.root, category_layout)) )
          @base = site.theme.root
      end
      
      super(@site, @base, '', category_layout)
      @dir = dir
      @name = page_name

      self.process @name

      @category = category
      @posts_in_category = posts_in_category
      @my_paginator = nil

      self.read_yaml(@base, category_layout)
      self.data.merge!('title' => category)
      if use_paginator
        @my_paginator = CategoryPager.new
        self.data.merge!('paginator' => @my_paginator)
      end
    end

    # Add relations of this page to other pages handled by a CategoryPager.
    #
    # Note that this method SHALL NOT be called if the category pages are instantiated without pagination.
    # This method SHALL be called if the category pages are instantiated with pagination.
    #
    # page               - Current page number.
    # per_page           - Posts per page.
    # total_pages        - Total number of pages.
    # previous_page      - Number of previous page or nil.
    # next_page          - Number of next page or nil.
    # previous_page_path - String with path to previous page or nil.
    # next_page_path     - String with path to next page or nil.
    def add_paginator_relations(page, per_page, total_pages, previous_page_path, next_page_path, previous_page, next_page)
      if @my_paginator
        @my_paginator.add_relations(page, per_page, total_pages,
                                    previous_page, next_page, previous_page_path, next_page_path)
        @my_paginator.add_posts(page, per_page, @posts_in_category)
      else
        Jekyll.logger.warn("Categories", "add_relations does nothing since the category page has been initialized without pagination")
      end
    end

    # Get the category name this index page refers to
    #
    # Returns a string.
    def category
      @category
    end

    # Get the paginator object describing the current index page.
    #
    # Returns a CategoryPager object or nil.
    def paginator
      @my_paginator
    end

    # Get all Posts in this category.
    #
    # Returns an Array of Posts.
    def posts
      @posts_in_category
    end

    # Get the number of posts in this category.
    #
    # Returns an Integer number of posts.
    def total_posts
      @posts_in_category.size
    end
  end

  # Handle pagination of category index pages.
  class CategoryPager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
                :previous_page, :previous_page_path, :next_page, :next_page_path

    # Static: Calculate the number of pages.
    #
    # all_posts - The Array of all Posts.
    # per_page  - The Integer of entries per page.
    #
    # Returns the Integer number of pages.
    def self.calculate_pages(all_posts, per_page)
      (all_posts.size.to_f / per_page.to_i).ceil
    end

    # Add numeric relationships of this page to other pages.
    #
    # page               - Current page number.
    # per_page           - Posts per page.
    # total_pages        - Total number of pages.
    # previous_page      - Number of previous page or nil.
    # next_page          - Number of next page or nil.
    # previous_page_path - String with path to previous page or nil.
    # next_page_path     - String with path to next page or nil.
    def add_relations(page, per_page, total_pages, previous_page, next_page, previous_page_path, next_page_path)
      @page = page
      @per_page = per_page
      @total_pages = total_pages
      @previous_page = previous_page
      @next_page = next_page
      @previous_page_path = previous_page_path
      @next_page_path = next_page_path
    end

    # Add page-specific post data.
    #
    # page              - Current page number.
    # per_page          - Posts per page.
    # posts_in_category - Array with full list of Posts in the current category.
    def add_posts(page, per_page, posts_in_category)
      total_posts = posts_in_category.size
      init = (page - 1) * per_page
      offset = (init + per_page - 1) >= total_posts ? total_posts : (init + per_page - 1)

      @total_posts = total_posts
      @posts = posts_in_category[init..offset]
    end

    # Convert this CategoryPager's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this CategoryPager.
    def to_liquid
      {
          'page' => page,
          'per_page' => per_page,
          'posts' => posts,
          'total_posts' => total_posts,
          'total_pages' => total_pages,
          'previous_page' => previous_page,
          'previous_page_path' => previous_page_path,
          'next_page' => next_page,
          'next_page_path' => next_page_path
      }
    end
  end
end
