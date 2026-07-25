---
layout: page
title: Prism — Make the web yours
id: prism
permalink: /prism/
excerpt: AI Chrome extension that lets you ship features to any website.
image: /assets/prism-logo-glass.png
---

<main class="prism-page">
  <header class="prism-hero">
  <nav class="prism-nav" aria-label="Prism links">
    <a href="https://github.com/sambharia/prism">github</a>
    <span aria-hidden="true">·</span>
    <a class="internal-link" href="#manifesto">manifesto</a>
    <span aria-hidden="true">·</span>
    <a class="internal-link" href="{{ site.baseurl }}/prism/quickstart/">quickstart</a>
  </nav>

    <h1>hi, this is prism.</h1>

    <div class="prism-pitch">
      <p class="prism-subtitle">it’s a chrome extension i made to make the web yours.</p>
      <p class="prism-intro">add a button, change the theme, remove clutter—kinda like shipping a new feature to any website.</p>
      <p class="prism-principles">open-source.<br>bring your own model.<br>your web, your way.</p>
    </div>

    <form
      class="prism-signup"
      id="prism-signup"
      action="{{ site.prism_signup_endpoint }}"
      method="post"
      data-signup-endpoint="{{ site.prism_signup_endpoint }}"
      data-download-url="{{ site.prism_download_url }}"
      data-quickstart-url="{{ site.baseurl }}/prism/quickstart/"
    >
      <label class="prism-sr-only" for="prism-email">email address</label>
      <div class="prism-form-row">
        <input id="prism-email" name="email" type="email" autocomplete="email" inputmode="email" placeholder="you@example.com" aria-describedby="prism-form-status" required>
        <button type="submit">download prism</button>
      </div>
      <input type="hidden" name="source" value="sambharia.com/prism">
      <input class="prism-honeypot" type="text" name="_gotcha" tabindex="-1" autocomplete="off" aria-hidden="true">
      <input type="hidden" name="_subject" value="New Prism download">
      <p class="prism-form-status" id="prism-form-status" role="status" aria-live="polite"></p>
    </form>

    <figure class="prism-demo" id="demo">
      <div class="prism-video-wrap">
        <iframe
          src="https://www.youtube-nocookie.com/embed/Lwyzux3kKVk"
          title="Prism demo"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowfullscreen
        ></iframe>
      </div>
      <figcaption>watch prism reshape the web.</figcaption>
    </figure>
  </header>

  <section class="prism-showcase" id="showcase" aria-label="Prism examples">
    <p class="prism-showcase-intro">a few ways i’ve made the web mine.</p>

    <div class="prism-showcase-list">
      <figure class="prism-showcase-item">
        <button class="prism-showcase-frame" type="button" data-full-src="{{ site.baseurl }}/assets/prism-demos/spiderman-theme.gif" aria-label="Expand: make it feel like yours">
          <img src="{{ site.baseurl }}/assets/prism-demos/spiderman-theme.gif" alt="Prism transforming sambharia.com into a Spider-Man-inspired theme" loading="lazy" decoding="async">
          <span class="prism-showcase-view" aria-hidden="true">view</span>
        </button>
        <figcaption>make it feel like yours.</figcaption>
      </figure>

      <figure class="prism-showcase-item">
        <button class="prism-showcase-frame" type="button" data-full-src="{{ site.baseurl }}/assets/prism-demos/distraction-free-x.gif" aria-label="Expand: keep the signal">
          <img src="{{ site.baseurl }}/assets/prism-demos/distraction-free-x.gif" alt="Prism creating a distraction-free version of X" loading="lazy" decoding="async">
          <span class="prism-showcase-view" aria-hidden="true">view</span>
        </button>
        <figcaption>keep the signal.</figcaption>
      </figure>

      <figure class="prism-showcase-item">
        <button class="prism-showcase-frame" type="button" data-full-src="{{ site.baseurl }}/assets/prism-demos/chat-md.gif" aria-label="Expand: add what’s missing">
          <img src="{{ site.baseurl }}/assets/prism-demos/chat-md.gif" alt="Prism adding a markdown editor to ChatGPT" loading="lazy" decoding="async">
          <span class="prism-showcase-view" aria-hidden="true">view</span>
        </button>
        <figcaption>add what’s missing.</figcaption>
      </figure>
    </div>
  </section>

  <dialog class="prism-lightbox" id="prism-lightbox" aria-label="Expanded Prism example">
    <div class="prism-lightbox-inner">
      <button class="prism-lightbox-close" type="button" aria-label="Close expanded example">close</button>
      <img src="" alt="">
    </div>
  </dialog>

  <article class="prism-manifesto" id="manifesto" aria-labelledby="manifesto-title">
    <p class="prism-kicker">manifesto</p>
    <h2 id="manifesto-title">i want the original internet back.</h2>

    <p>the original internet incentivized creativity. people all over the world had their own place on it, connected by open protocols like smtp, http, and tcp/ip.</p>

    <p>that idea was slowly taken from us by platforms, each one trying to lock us inside its own ecosystem.</p>

    <p>but that’s enough.</p>

    <p>i want the original internet back, a place where people made it their own, like drivers in tokyo who take a stock car and customize it until it becomes theirs.</p>

    <p><em>have you ever used a website and thought:</em></p>
    <ul>
      <li><em>why can’t i change this?</em></li>
      <li><em>why didn’t they think of this?</em></li>
      <li><em>why can’t i choose what i see?</em></li>
    </ul>

    <p>answering these questions led me to prism. prism is a chrome extension that lets you ship features to any website in natural language, using ai. it lets you dream about what the web could be, then make it real.</p>

    <p class="prism-closing">try it today. <a href="#prism-signup">download prism</a> <span aria-hidden="true">·</span> <a href="https://github.com/sambharia/prism">view the source</a></p>
  </article>
</main>

<script>
  (function () {
    var lightbox = document.getElementById('prism-lightbox');
    var lightboxImage = lightbox && lightbox.querySelector('img');
    var lightboxClose = lightbox && lightbox.querySelector('.prism-lightbox-close');

    if (lightbox && lightboxImage && lightboxClose) {
      document.querySelectorAll('.prism-showcase-frame').forEach(function (trigger) {
        trigger.addEventListener('click', function () {
          var thumbnail = trigger.querySelector('img');
          lightboxImage.src = trigger.dataset.fullSrc;
          lightboxImage.alt = thumbnail ? thumbnail.alt : '';
          lightbox.showModal();
        });
      });

      lightboxClose.addEventListener('click', function () {
        lightbox.close();
      });

      lightbox.addEventListener('click', function (event) {
        if (event.target === lightbox) lightbox.close();
      });
    }

    var form = document.getElementById('prism-signup');
    var status = document.getElementById('prism-form-status');
    if (!form || !status) return;

    form.addEventListener('submit', async function (event) {
      event.preventDefault();

      var signupEndpoint = form.dataset.signupEndpoint.trim();
      var downloadUrl = form.dataset.downloadUrl.trim();
      var quickstartUrl = form.dataset.quickstartUrl;
      var button = form.querySelector('button[type="submit"]');

      if (!signupEndpoint || !downloadUrl) {
        status.textContent = 'email signup isn’t connected yet. please use the release link above for now.';
        status.className = 'prism-form-status is-error';
        return;
      }

      // Opening this tab inside the click event keeps it from being blocked after
      // the asynchronous email submission completes.
      var quickstartWindow = window.open('about:blank', '_blank');
      if (quickstartWindow) {
        quickstartWindow.document.title = 'opening prism quickstart…';
        quickstartWindow.document.body.innerHTML = '<p style="font:16px system-ui;padding:32px">opening prism quickstart…</p>';
      }

      button.disabled = true;
      button.textContent = 'getting prism…';
      status.textContent = '';

      try {
        var response = await fetch(signupEndpoint, {
          method: 'POST',
          body: new FormData(form),
          headers: { 'Accept': 'application/json' }
        });

        var result = await response.json().catch(function () { return {}; });
        if (!response.ok) {
          var message = Array.isArray(result.errors)
            ? result.errors.map(function (item) { return item.message; }).join(' ')
            : 'that didn’t go through. please try again.';
          throw new Error(message);
        }

        status.textContent = 'your download is starting…';
        status.className = 'prism-form-status is-success';

        if (quickstartWindow) {
          quickstartWindow.location.replace(quickstartUrl);
          window.location.assign(downloadUrl);
        } else {
          var downloadFrame = document.createElement('iframe');
          downloadFrame.hidden = true;
          downloadFrame.src = downloadUrl;
          document.body.appendChild(downloadFrame);
          window.setTimeout(function () { window.location.assign(quickstartUrl); }, 800);
        }
      } catch (error) {
        if (quickstartWindow) quickstartWindow.close();
        status.textContent = error.message || 'that didn’t go through. please try again.';
        status.className = 'prism-form-status is-error';
        button.disabled = false;
        button.textContent = 'download prism';
      }
    });
  }());
</script>

<style>
  .prism-page {
    --ink: hsl(0, 0%, 10%);
    --text: hsl(0, 0%, 20%);
    --muted: hsl(0, 0%, 40%);
    --line: hsl(0, 0%, 85%);
    --blue: #2a2ecd;
    color: var(--ink);
  }
  .prism-nav { display: flex; flex-wrap: wrap; gap: 0.35em; margin: 0 0 1.25em; color: var(--muted); font-size: 0.8em; }
  .prism-nav a, .prism-nav a:visited { padding: 0; border-bottom: none; color: var(--muted); }
  .prism-nav a::after { content: ''; }
  .prism-nav a:hover { color: var(--blue) !important; background: none; }
  .prism-hero { padding: 0 0 2.25em; }
  .prism-hero h1, .prism-manifesto h2 { color: var(--ink); letter-spacing: -0.025em; }
  .prism-hero h1 { margin: 0 0 0.5em; font-size: 2.35rem; line-height: 1.08; }
  .prism-pitch { margin: 0 0 0.65em; }
  .prism-subtitle, .prism-intro, .prism-principles { max-width: 38em; color: var(--muted); font-size: 1.15em; line-height: 1.55; }
  .prism-subtitle, .prism-intro { margin: 0 0 0.75em; }
  .prism-principles { margin: 0; }
  .prism-signup { max-width: 31em; margin: 1.25em 0 0; }
  .prism-sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0; }
  .prism-honeypot { position: absolute !important; left: -9999px !important; width: 1px !important; height: 1px !important; opacity: 0 !important; pointer-events: none !important; }
  .prism-form-row { display: flex; gap: 0.55em; }
  .prism-form-row input { min-width: 0; flex: 1; padding: 0.72em 0.8em; border: 1px solid var(--line); border-radius: 4px; background: #fff; color: var(--ink); font: inherit; }
  .prism-form-row input:focus { outline: 2px solid #cfd1ff; border-color: var(--blue); }
  .prism-form-row button { padding: 0.72em 1em; border: 1px solid var(--blue); border-radius: 4px; background: var(--blue); color: #fff; font: inherit; cursor: pointer; }
  .prism-form-row button:hover { background: #2024ad; }
  .prism-form-row button:disabled { cursor: wait; opacity: 0.65; }
  .prism-form-status { margin: 0.55em 0 0; color: var(--muted); font-size: 0.75em; line-height: 1.45; }
  .prism-form-status:empty { display: none; }
  .prism-form-status.is-error { color: #a23b31; }
  .prism-form-status.is-success { color: #25713a; }
  .prism-demo { width: min(100%, 36em); margin: 1.5em 0 0; }
  .prism-video-wrap { position: relative; }
  .prism-video-wrap iframe { display: block; width: 100%; aspect-ratio: 16 / 9; border: 1px solid var(--line); border-radius: 4px; background: #111; }
  .prism-demo figcaption { margin-top: 0.5em; color: var(--muted); font-size: 0.8em; font-style: italic; }
  .prism-showcase { padding: 2.25em 0 2.75em; border-top: 1px solid var(--line); }
  .prism-showcase-intro { margin: 0 0 1.15em; color: var(--muted); font-size: 0.9em; }
  .prism-showcase-list { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 0.75em; }
  .prism-showcase-item { margin: 0; }
  .prism-showcase-item figcaption { margin-top: 0.55em; color: var(--muted); font-size: 0.75em; line-height: 1.4; }
  .prism-showcase-frame { position: relative; display: block; width: 100%; padding: 0; overflow: hidden; border: 1px solid var(--line); border-radius: 4px; background: #111; cursor: zoom-in; }
  .prism-showcase-frame img { display: block; width: 100%; height: auto; }
  .prism-showcase-view { position: absolute; right: 0.5em; bottom: 0.5em; padding: 0.3em 0.55em; border-radius: 999px; background: rgba(17, 17, 17, 0.78); color: #fff; font-size: 0.65rem; opacity: 0; transition: opacity 120ms ease; }
  .prism-showcase-frame:hover .prism-showcase-view, .prism-showcase-frame:focus-visible .prism-showcase-view { opacity: 1; }
  .prism-showcase-frame:focus-visible { outline: 3px solid #cfd1ff; outline-offset: 2px; }
  .prism-lightbox { max-width: none; max-height: none; padding: 0; border: 0; background: transparent; overflow: visible; }
  .prism-lightbox::backdrop { background: rgba(9, 9, 12, 0.84); backdrop-filter: blur(8px); }
  .prism-lightbox-inner { position: relative; }
  .prism-lightbox img { display: block; max-width: min(92vw, 1120px); max-height: 88vh; border-radius: 8px; box-shadow: 0 24px 80px rgba(0, 0, 0, 0.45); object-fit: contain; }
  .prism-lightbox-close { position: absolute; z-index: 1; top: 0.75em; right: 0.75em; padding: 0.45em 0.7em; border: 1px solid rgba(255, 255, 255, 0.45); border-radius: 999px; background: rgba(17, 17, 17, 0.82); color: #fff; font: inherit; font-size: 0.72rem; cursor: pointer; }
  .prism-manifesto { padding: 2.5em 0 1em; border-top: 1px solid var(--line); }
  .prism-kicker { margin: 0 0 0.5em; color: var(--blue); font-size: 0.75rem; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; }
  .prism-manifesto h2 { margin: 0 0 1em; font-size: 1.8rem; line-height: 1.2; }
  .prism-manifesto > p:not(.prism-kicker):not(.prism-closing), .prism-manifesto > ul { color: var(--text); font-size: 1em; line-height: 1.65; }
  .prism-manifesto ul { padding-left: 1.4em; }
  .prism-closing { margin-top: 2em; }
  @media (max-width: 560px) {
    .prism-hero h1 { font-size: 2rem; }
    .prism-subtitle { font-size: 1em; }
    .prism-form-row { flex-direction: column; }
    .prism-form-row button { width: 100%; }
    .prism-showcase-list { grid-template-columns: repeat(3, minmax(12em, 1fr)); overflow-x: auto; padding-bottom: 0.5em; scroll-snap-type: x proximity; }
    .prism-showcase-item { scroll-snap-align: start; }
  }
</style>
