---
title: jekyll-category-pages example project
layout: basic
---

<p>These are the categories for all blog posts:</p>
<ul>
{% for category in site.categories %}
<li><a href="{{ site.url }}/jekyll/category/{{ category | first | url_encode }}/index.html">{{ category | first }}</a></li>
{% endfor %}
</ul>
<p>They link to the corresponding index pages!</p>

