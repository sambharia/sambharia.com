---
layout: page
title: Home
id: home
permalink: /
---

<div class="home-profile">
  <img src="{{ site.baseurl }}/images/me.jpg" alt="Siddharth Sambharia" class="profile-photo">
  <p class="profile-links">
    <a href="https://x.com/siddhxrth10">X</a> · <a href="https://github.com/siddharthsambharia-portkey">GitHub</a> · <a href="https://www.linkedin.com/in/siddharthsambharia">LinkedIn</a> · <a href="mailto:sam.siddharth10@gmail.com">Email</a>
  </p>
</div>

i work at [Portkey](https://portkey.ai) - 7th hire, now acquired by Palo Alto Networks - and do side projects on weekends. I have been lucky to discover the work of inspiring people from around the world early in my life, which has greatly influenced my own work and ideas

i’m most active on [X](https://x.com/siddhxrth10) (sometimes more than i would like)

---

## things i believe

- the cost of energy will come close to 0 in the coming decades
- number of iterations is the key to successful things
- good artists copy, great artists steal
- agency is the most important thing if intelligence becomes democratized

---

## writing

<ul class="writing-list">
  {% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in notes %}
    <li>
      <span class="note-date">{{ note.last_modified_at | date: "%Y-%m-%d" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

<a class="internal-link all-writing" href="{{ site.baseurl }}/writing">all writing →</a>

---

## things i like

a small list of talks, books, and films i keep coming back to.

<a class="internal-link all-writing" href="{{ site.baseurl }}/likes">see the list →</a>

---

## cool people

i like the idea of writer builders mentioned [here](https://www.workingtheorys.com/p/writer-builder)

there are few things that can give you asymmetric returns in life. this website is one experiment to get asymmetric returns. hopefully someone is interested in what i write and it lands into something tangible. or maybe my future wife reads this, i don’t know

here’s a list of cool people on the internet that inspired me to write this (with some web presence):

Anu Atluru · Paras Chopra · Paul Graham · Alexey Guzey · Dwarkesh Patel · Patrick Collison · Nat Friedman

(too lazy to add links, you can find them yourself!)in

<style>
  .wrapper { max-width: 42em; margin: 0 auto; }
  .writing-list {
    list-style: none;
    padding: 0;
    margin: 0.5em 0 0.8em;
  }
  .writing-list li {
    display: flex;
    gap: 0.8em;
    align-items: baseline;
    margin: 0.35em 0;
  }
  .note-date {
    color: hsl(0, 0%, 55%);
    font-size: 0.78em;
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
    flex-shrink: 0;
  }
  .all-writing {
    font-size: 0.88em;
    color: hsl(0, 0%, 45%);
    border-bottom: none;
  }
  .all-writing:visited { color: hsl(0, 0%, 45%); }
</style>
