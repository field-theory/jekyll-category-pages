---
layout: basic
---
{% if page.paginator %}

  <!-- Pagination is active -->
  {% assign paginator = page.paginator %}

  {% if paginator.previous_page != nil or paginator.next_page != nil %}
    <!-- Show page number if we have multiple pages -->
    <h1>Category index page {{ paginator.page }} / {{ paginator.total_pages }} for &ldquo;{{ page.title }}&rdquo;</h1>
  {% else %}
    <!-- No page number if we only have a single page -->
    <h1>Category index for &ldquo;{{ page.title }}&rdquo;</h1>
  {% endif %}

  <section>
    <!-- Show post excerpts for the current page -->
    {% for post in paginator.posts limit:paginator.per_page %}
      <article>
        <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
        <h5>{{ post.date }}</h5>
        <p>{{ post.excerpt }}</p>
      </article>
    {% endfor %}
  </section>
  <!-- Show navigation next/previous page links if applicable -->
  <nav><p>
    {% if paginator.previous_page %}<a href="{{ paginator.previous_page_path }}"><span aria-hidden="true">&larr;</span> Newer</a>{% endif %}
    {% if paginator.next_page %}<a href="{{ paginator.next_page_path }}">Older <span aria-hidden="true">&rarr;</span></a>{% endif %}
  </p></nav>

{% else %}

  <!-- Pagination is not active -->
  <h1>Category index for &ldquo;{{ page.title }}&rdquo;</h1>

  <section>
    <!-- Show excerpts for all posts in this category -->
    {% for post in page.posts %}
      <article>
        <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
        <h5>{{ post.date }}</h5>
        <p>{{ post.excerpt }}</p>
      </article>
    {% endfor %}
  </section>

{% endif %}

