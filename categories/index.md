---
layout: static
permalink: /categories/
title: Categories
excerpt: "Categories"
modified: 2017-07-09T19:44:38.564948-04:00
---


<div id="archives">
{% for category in site.categories %}
  <div class="archive-group">
    {% capture category_name %}{{ category | first }}{% endcapture %}
    <div id="#{{ category_name | slugize }}"></div>
    <p></p>
    <h1 class="category-head">{{ category_name }}</h1>
    <a name="{{ category_name | slugize }}"></a>
    {% for post in site.categories[category_name] %}
      <h4><a href="{{ site.baseurl }}{{ post.url }}">{{post.title}}</a></h4>
      tags:
        {% for tags in post.tags %}
        {{ tags }}
        {% if forloop.rindex > 1 %}
            ,
        {% endif %}
        {% endfor %}
        <hr>
    {% endfor %}
  </div>
{% endfor %}
</div>