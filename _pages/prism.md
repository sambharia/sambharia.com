---
layout: page
title: Prism — Make the web yours
id: prism
permalink: /prism/
excerpt: Prism is a Chrome extension that lets you reshape any website with natural language.
image: /assets/prism-logo-glass.png
---

<div class="prism-page">
  <header class="prism-hero">
    <img class="prism-logo" src="{{ site.baseurl }}/assets/prism-logo-glass.png" alt="Prism">
    <p class="prism-eyebrow"><a href="https://github.com/sambharia/prism">GitHub</a> <span aria-hidden="true">|</span> <a href="#manifesto" class="internal-link">Manifesto</a></p>
    <h1>Prism</h1>
    <p class="prism-tagline">Make the web truly yours.</p>
    <p class="prism-lede">A Chrome extension that lets you customize websites using natural language, whether that means adding a button, changing the theme, or making a website work the way you always wanted it to.</p>

    <p class="prism-section-label">What Prism does</p>
    <h2 id="what-prism-does">Your words become working changes.</h2>
    <div class="prism-prompt-list" aria-label="Example Prism prompts">
      <p>“Hide the right sidebar and give the article more room.”</p>
      <p>“Add a copy button beside every code block.”</p>
      <p>“Make this pricing table easier to compare.”</p>
      <p>“Export the visible profile handles as CSV.”</p>
    </div>

    <form class="prism-signup" id="prism-signup" method="post" data-form-id="{{ site.prism_formspree_id }}" data-download-url="{{ site.prism_download_url }}">
      <label class="prism-sr-only" for="prism-email">Email address</label>
      <div class="prism-form-row">
        <input id="prism-email" name="email" type="email" autocomplete="email" inputmode="email" placeholder="ron@hogwarts.com" required>
        <button type="submit">download</button>
      </div>
      <input type="hidden" name="source" value="sambharia.com/prism">
      <p class="prism-form-status" id="prism-form-status" role="status" aria-live="polite"></p>
    </form>

    <p class="prism-secondary-links"><a href="https://github.com/sambharia/prism">View source on GitHub</a> <span aria-hidden="true">·</span> <a href="#quick-start" class="internal-link">Quick start</a></p>
  </header>

  <hr>

  <section id="quick-start">
    <p class="prism-section-label">Quick start</p>
    <ol class="prism-steps">
      <li><span>1</span><div><strong>Install Prism.</strong><br>Download the ZIP, unzip it, then open <code>chrome://extensions</code>. Enable Developer mode, choose <strong>Load unpacked</strong>, and select the unzipped folder.</div></li>
      <li><span>2</span><div><strong>Connect your model.</strong><br>Open Prism with <kbd>⌘</kbd><kbd>⇧</kbd><kbd>X</kbd> on Mac or <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>X</kbd> elsewhere. Type <code>/settings</code> and add your AI provider.</div></li>
      <li><span>3</span><div><strong>Change the web.</strong><br>Open any website, summon Prism, describe what you want, and press Enter.</div></li>
    </ol>
    <p class="prism-small">Prism supports Chrome 135+ and uses your own OpenAI, Anthropic, or compatible provider credentials.</p>
  </section>

  <hr>

  <article class="prism-manifesto" id="manifesto" aria-labelledby="manifesto-title">
    <p class="prism-section-label">Manifesto</p>
    <h2 id="manifesto-title">I Want the Original Internet Back</h2>

    <p>The original internet incentivized creativity. People from all over the world had their own place on it, connected through open protocols like SMTP, HTTP, and TCP/IP.</p>

    <p>This idea of the open internet was slowly taken away from us by platforms, with everyone trying to lock us inside their own ecosystem. Over the last decade we have seen platforms take power away from people while stuffing everything with ads.</p>

    <p>But that’s enough. I want the original internet back — a place where people made it their own, like drivers in Tokyo who take a stock car and customize it until it becomes their own.</p>

    <p><em>Have you ever used a website and thought:</em></p>
    <ul>
      <li><em>Why can’t I change this?</em></li>
      <li><em>Why isn’t there a button that does what I need?</em></li>
      <li><em>Why must I use software the way someone else decided?</em></li>
    </ul>

    <p>AI gives us agency. You can take something you’ve imagined and make it real. You can use it to reshape the web around you and make the software you use feel more personal.</p>

    <p>I like the idea where Steve Jobs said, “Real artists ship.” I built Prism to help you ship things directly onto the web.</p>

    <p>Prism Chrome extension that lets you customize websites using natural language, whether that means adding a button, changing the theme, or making a website work the way you always wanted it to.</p>

    <p>I’m super excited to bring this into the world. Prism lets you dream about what the web could be and then make it real.</p>
  </article>

</div>

<script>
  (function () {
    var form = document.getElementById('prism-signup');
    var status = document.getElementById('prism-form-status');
    if (!form || !status) return;

    form.addEventListener('submit', async function (event) {
      event.preventDefault();
      var formId = form.dataset.formId.trim();
      var downloadUrl = form.dataset.downloadUrl;
      var button = form.querySelector('button[type="submit"]');

      if (!formId) {
        status.textContent = 'The download is being prepared. Follow Prism on GitHub for release updates.';
        status.className = 'prism-form-status is-error';
        return;
      }

      button.disabled = true;
      button.textContent = 'Submitting…';
      status.textContent = '';

      try {
        var response = await fetch('https://formspree.io/f/' + encodeURIComponent(formId), {
          method: 'POST',
          body: new FormData(form),
          headers: { 'Accept': 'application/json' }
        });

        if (!response.ok) throw new Error('Submission failed');
        status.textContent = 'Opening Prism…';
        status.className = 'prism-form-status is-success';
        window.setTimeout(function () { window.location.assign(downloadUrl); }, 500);
      } catch (error) {
        status.textContent = 'That didn’t go through. Please try again.';
        status.className = 'prism-form-status is-error';
        button.disabled = false;
        button.textContent = 'download';
      }
    });
  }());
</script>

<style>
  .prism-page { --prism-ink: #11131d; --prism-muted: #64646d; --prism-line: #dedee4; --prism-blue: #2a2ecd; }
  .prism-page h1, .prism-page h2 { color: var(--prism-ink); letter-spacing: -0.035em; }
  .prism-page h1 { max-width: 10em; margin: 0.3em 0 0.25em; font-size: clamp(2.65rem, 10vw, 4.8rem); line-height: 0.98; }
  .prism-page h2 { font-size: clamp(1.65rem, 5vw, 2.35rem); line-height: 1.08; margin-top: 0.25em; }
  .prism-tagline { margin: 0; color: var(--prism-ink); font-size: clamp(1.35rem, 4vw, 1.8rem); font-weight: 650; letter-spacing: -0.025em; }
  .prism-page section, .prism-manifesto { padding: 2.2em 0; }
  .prism-page hr { margin: 0; }
  .prism-hero { padding: 2.2em 0 3em; }
  .prism-logo { width: 78px; height: 78px; margin: 0 0 1.45em; border-radius: 18px; box-shadow: 0 12px 36px rgba(22, 24, 48, 0.17); }
  .prism-eyebrow { margin: 0; color: var(--prism-blue); font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .prism-eyebrow a, .prism-eyebrow a:visited { color: var(--prism-blue); }
  .prism-section-label { margin: 0; color: var(--prism-blue); font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .prism-lede { max-width: 34em; margin: 1.15em 0 1.75em; color: #3f3f48; font-size: 1.15rem; line-height: 1.58; }
  .prism-signup { max-width: 30rem; margin-top: 1.6em; }
  .prism-sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0; }
  .prism-form-row { display: flex; gap: 0.6em; }
  .prism-form-row input { min-width: 0; flex: 1; padding: 0.8em 0.9em; border: 2px solid var(--prism-line); border-radius: 8px; background: #fff; color: var(--prism-ink); font: inherit; }
  .prism-form-row input:focus { outline: 2px solid #acafff; outline-offset: 1px; }
  .prism-form-row button { padding: 0.8em 1.1em; border: 1px solid var(--prism-blue); border-radius: 8px; background: var(--prism-blue); color: #fff; font: inherit; cursor: pointer; white-space: nowrap; }
  .prism-form-row button:hover { background: #2024ad; }
  .prism-form-row button:disabled { cursor: wait; opacity: 0.65; }
  .prism-form-status, .prism-small { margin: 0.65em 0 0; color: var(--prism-muted); font-size: 0.76rem; line-height: 1.45; }
  .prism-form-status:empty { display: none; }
  .prism-form-status.is-error { color: #a43b32; }
  .prism-form-status.is-success { color: #27633a; }
  .prism-secondary-links { margin: 1em 0 0; color: var(--prism-muted); font-size: 0.84rem; }
  .prism-prompt-list { margin: 1.45em 0; padding-left: 1em; border-left: 2px solid var(--prism-blue); }
  .prism-prompt-list p { margin: 0 0 0.45em; color: #34343c; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 0.86rem; }
  .prism-steps { list-style: none; padding: 0; margin: 1.5em 0; }
  .prism-steps li { display: grid; grid-template-columns: 2em 1fr; gap: 0.8em; margin-bottom: 1.2em; }
  .prism-steps li > span { display: grid; width: 1.9em; height: 1.9em; place-items: center; border: 1px solid var(--prism-line); border-radius: 50%; color: var(--prism-blue); font-size: 0.76rem; font-weight: 700; }
  .prism-steps code, .prism-steps kbd { padding: 0.12em 0.3em; border: 1px solid #dedee4; border-radius: 3px; background: #f5f5f7; font-size: 0.82em; }
  .prism-manifesto > p:not(.prism-section-label), .prism-manifesto > ul { font-family: Georgia, 'Times New Roman', serif; font-size: 1.08rem; line-height: 1.75; }
  .prism-manifesto > p:first-of-type + h2 { margin-bottom: 0.8em; }
  @media (max-width: 560px) {
    .prism-hero { padding-top: 1.25em; }
    .prism-form-row { flex-direction: column; }
    .prism-form-row button { width: 100%; }
  }
</style>
