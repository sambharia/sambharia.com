---
layout: page
title: writing
permalink: /writing
---

<ul class="notes-list">
  {% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in notes %}
    <li>
      <span class="note-date">{{ note.last_modified_at | date: "%Y-%m-%d" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

<style>
  .notes-list {
    list-style: none;
    padding: 0;
    margin: 1em 0 0;
  }
  .notes-list li {
    display: flex;
    gap: 1em;
    align-items: baseline;
    margin: 0.6em 0;
  }
  .note-date {
    color: hsl(0, 0%, 55%);
    font-size: 0.78em;
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
    flex-shrink: 0;
  }
  .wrapper {
    max-width: 44em;
  }
</style>
