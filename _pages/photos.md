---
layout: page
title: photos
permalink: /photos
description: A running log of some of my favorite photos.
---

<div class="photos-page">
  <header class="photos-intro">
    <p class="photos-kicker">a running log</p>
    <h1>photos</h1>
    <p class="photos-description">Some moments, places, and things I want to remember.</p>
  </header>

  <div class="photo-grid">
    {% for photo in site.data.photos %}
      <figure class="photo-card">
        <a href="{{ site.baseurl }}{{ photo.src }}" class="photo-link">
          <img src="{{ site.baseurl }}{{ photo.src }}" alt="{{ photo.alt }}" loading="lazy">
        </a>
        {% if photo.caption %}
          <figcaption>{{ photo.caption }}</figcaption>
        {% endif %}
      </figure>
    {% endfor %}
  </div>

  {% if site.data.photos == empty %}
    <p class="photos-empty">No photos yet.</p>
  {% endif %}
</div>

<style>
  .photos-page {
    margin-top: 2.8em;
  }

  .photos-intro {
    margin: 0 auto 2.4em;
    max-width: 34em;
  }

  .photos-kicker {
    color: hsl(0, 0%, 52%);
    font-size: 0.78em;
    letter-spacing: 0.09em;
    margin: 0 0 0.3em;
    text-transform: uppercase;
  }

  .photos-intro h1 {
    font-size: clamp(2.1rem, 7vw, 3.25rem);
    letter-spacing: -0.04em;
    margin: 0 0 0.2em;
  }

  .photos-description {
    color: hsl(0, 0%, 42%);
    font-size: 1.05em;
    margin: 0;
  }

  .photo-grid {
    columns: 2 14em;
    column-gap: 1em;
  }

  .photo-card {
    break-inside: avoid;
    margin: 0 0 1em;
  }

  .photo-link {
    background: none;
    border: 0;
    display: block;
    padding: 0;
  }

  .photo-link:after {
    content: "";
  }

  .photo-link img {
    border-radius: 3px;
    display: block;
    height: auto;
    margin: 0;
    max-height: none;
    object-fit: cover;
    transition: filter 200ms, transform 200ms;
    width: 100%;
  }

  .photo-link:hover img {
    filter: brightness(0.94);
    transform: translateY(-2px);
  }

  .photo-card figcaption {
    color: hsl(0, 0%, 50%);
    font-size: 0.78em;
    line-height: 1.4;
    margin-top: 0.45em;
  }

  .photos-empty {
    border-top: 1px solid hsl(0, 0%, 85%);
    color: hsl(0, 0%, 50%);
    font-size: 0.95em;
    margin-top: 2.5em;
    padding-top: 1em;
  }

  @media (max-width: 640px) {
    .photos-page {
      margin-top: 2em;
    }

    .photo-grid {
      columns: 1;
    }
  }
</style>
