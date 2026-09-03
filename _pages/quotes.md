---
layout: page
title: quotes
permalink: /quotes
---

<div class="quotes-page">
  <h1>quotes</h1>

  <ul class="quotes-list">
    {% for quote in site.data.quotes %}
      <li>
        <blockquote>“{{ quote.text }}”</blockquote>
        <p class="quote-attribution">— {{ quote.author }}</p>
      </li>
    {% endfor %}
  </ul>
</div>

<style>
  .quotes-page {
    font-family: inherit;
    margin-top: 2.8em;
  }

  .quotes-page h1 {
    font-size: clamp(2.1rem, 7vw, 3.25rem);
    letter-spacing: -0.04em;
    margin: 0 0 1.1em;
  }

  .quotes-list {
    list-style: none;
    margin: 0;
    padding: 0;
  }

  .quotes-list li {
    margin: 0 0 1.7em;
  }

  .quotes-list li:last-child {
    margin-bottom: 0;
  }

  .quotes-list blockquote {
    color: hsl(0, 0%, 28%);
    margin: 0;
  }

  .quote-attribution {
    color: hsl(0, 0%, 50%);
    font-size: 0.85em;
    margin: 0.4em 0 0 1.1em;
  }
</style>
