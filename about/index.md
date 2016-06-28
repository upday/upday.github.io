---
layout: page
title: About
excerpt: "About"
modified: 2014-08-08T19:44:38.564948-04:00
---
<figure class="fith">
    {% assign devs = site.data.developers | sort: 'name' %}
    {% for developer in devs %}
	    <a href="http://twitter.com/{% if developer.twitter != null %}{{ developer.twitter}}{% else %}UpdayDevs{% endif %}" title="{{ developer.name }}"><img src="https://github.com/{{ developer.github }}.png" alt="image"></a>
    {% endfor %}
  <figcaption>Our Updudettes & Updudes</figcaption>
</figure>
