---
layout: page
title: Prism quickstart
id: prism-quickstart
permalink: /prism/quickstart/
excerpt: Install Prism and make your first change in a few minutes.
---

<main class="quickstart-page">
  <div class="quickstart-profile">
    <a class="quickstart-logo-link internal-link" href="{{ site.baseurl }}/prism/" aria-label="Back to Prism">
      <img class="quickstart-logo" src="{{ site.baseurl }}/assets/prism-logo-glass.png" alt="Prism logo">
    </a>
    <nav class="quickstart-nav" aria-label="Prism links">
      <a class="internal-link" href="{{ site.baseurl }}/prism/">← prism</a>
      <span aria-hidden="true">·</span>
      <a href="https://github.com/sambharia/prism">github</a>
      <span aria-hidden="true">·</span>
      <a class="internal-link" href="{{ site.baseurl }}/prism/#manifesto">manifesto</a>
    </nav>
  </div>

  <header class="quickstart-hero">
    <p class="quickstart-kicker">quickstart</p>
    <h1>let’s get prism running.</h1>
    <p>your download should have started. you only need to do this setup once—it usually takes about five minutes.</p>
    <p class="quickstart-download-help">nothing downloaded? <a href="{{ site.baseurl }}/prism/#prism-signup">enter your email again</a>.</p>
  </header>

  <ol class="quickstart-steps">
    <li class="quickstart-step">
      <div class="step-number">1</div>
      <div class="step-copy">
        <h2>unzip prism.</h2>
        <p>open your Downloads folder and double-click the Prism ZIP. you’ll get a normal folder named <strong>prism</strong>. leave that folder somewhere you won’t delete it.</p>
        <div class="finder-visual setup-visual" role="img" aria-label="A Prism zip file becoming an unzipped Prism folder">
          <div class="file-card"><span class="zip-icon">ZIP</span><span>prism.zip</span></div>
          <span class="visual-arrow" aria-hidden="true">→</span>
          <div class="file-card"><span class="folder-icon" aria-hidden="true"></span><span>prism</span></div>
        </div>
      </div>
    </li>

    <li class="quickstart-step">
      <div class="step-number">2</div>
      <div class="step-copy">
        <h2>open chrome’s extensions page.</h2>
        <p>copy <code>chrome://extensions</code>, paste it into Chrome’s address bar, and press Enter. turn on <strong>Developer mode</strong> in the top-right, then click <strong>Load unpacked</strong>.</p>
        <img class="setup-screenshot" src="{{ site.baseurl }}/assets/prism-quickstart/chrome-extensions.png" alt="Chrome Extensions page with Developer mode enabled and Load unpacked visible">
      </div>
    </li>

    <li class="quickstart-step">
      <div class="step-number">3</div>
      <div class="step-copy">
        <h2>choose the prism folder.</h2>
        <p>in the window that opens, select the <strong>prism</strong> folder you just unzipped, then click <strong>Select</strong> or <strong>Open</strong>. Prism will now appear on the Extensions page.</p>
        <div class="picker-visual setup-visual" role="img" aria-label="File picker with the unzipped Prism folder selected">
          <div class="picker-bar"><span></span><span></span><span></span><strong>Downloads</strong></div>
          <div class="picker-body"><div class="folder-icon large" aria-hidden="true"></div><strong>prism</strong></div>
          <div class="picker-footer"><span>select the whole folder—not a file inside it.</span><button type="button" tabindex="-1">Open</button></div>
        </div>
      </div>
    </li>

    <li class="quickstart-step">
      <div class="step-number">4</div>
      <div class="step-copy">
        <h2>allow user scripts.</h2>
        <p>on Prism’s extension card, click <strong>Details</strong>. scroll down and switch on <strong>Allow User Scripts</strong>. if you don’t see it, make sure Chrome is up to date.</p>
        <img class="setup-screenshot wide-shot" src="{{ site.baseurl }}/assets/prism-quickstart/allow-user-scripts.png" alt="Allow User Scripts switch on a Chrome extension details page">
      </div>
    </li>

    <li class="quickstart-step">
      <div class="step-number">5</div>
      <div class="step-copy">
        <h2>pin prism.</h2>
        <p>click Chrome’s puzzle-piece Extensions icon, find Prism, and click the pin. the Prism icon will stay beside your address bar.</p>
        <div class="toolbar-visual setup-visual" role="img" aria-label="Chrome Extensions menu showing Prism and its pin button">
          <div class="fake-address">sambharia.com</div>
          <span class="puzzle" aria-hidden="true">✦</span>
          <div class="extension-menu"><strong>Extensions</strong><div><img src="{{ site.baseurl }}/assets/prism-logo-glass.png" alt=""><span>Prism</span><span class="pin" aria-hidden="true">⌖</span></div></div>
        </div>
      </div>
    </li>

    <li class="quickstart-step">
      <div class="step-number">6</div>
      <div class="step-copy">
        <h2>connect your model.</h2>
        <p>open any normal website. press <kbd>⌘</kbd> <kbd>⇧</kbd> <kbd>X</kbd> on Mac or <kbd>Ctrl</kbd> <kbd>⇧</kbd> <kbd>X</kbd> on Windows/Linux. type <code>/settings</code>, open <strong>AI connection</strong>, then add your provider, model, and API key. click <strong>Test connection</strong>, then <strong>Save connection</strong>.</p>
        <img class="setup-screenshot prism-settings-screenshot" src="{{ site.baseurl }}/assets/prism-quickstart/settings.png" alt="Prism’s real AI connection settings screen with provider, model, reasoning, API key, test, and save controls">
        <p class="privacy-note">your credentials stay in Chrome’s local extension storage. Prism sends your prompt and relevant visible page content to the provider you choose.</p>
      </div>
    </li>

    <li class="quickstart-step final-step">
      <div class="step-number">7</div>
      <div class="step-copy">
        <h2>make the web yours.</h2>
        <p>press the shortcut again and try something small:</p>
        <blockquote>“hide the right sidebar and give the article more room.”</blockquote>
        <p>press Enter. Prism will inspect the page, make the change, and remember it for that website.</p>
        <a class="back-to-demo" href="{{ site.baseurl }}/prism/#demo">watch the demo again →</a>
      </div>
    </li>
  </ol>

  <footer class="quickstart-footer">
    <p>stuck? check the <a href="https://github.com/sambharia/prism#troubleshooting">troubleshooting guide</a> or <a href="https://github.com/sambharia/prism/issues">open an issue</a>.</p>
    <p class="image-credit">Chrome interface screenshots adapted from <a href="https://developer.chrome.com/docs/extensions/reference/api/userScripts">Google Chrome for Developers</a>, licensed CC BY 4.0.</p>
  </footer>
</main>

<style>
  .quickstart-page { --ink: hsl(0, 0%, 10%); --muted: hsl(0, 0%, 40%); --soft: #f7f7f7; --line: hsl(0, 0%, 85%); --blue: #2a2ecd; color: var(--ink); }
  .quickstart-page a, .quickstart-page a:visited { color: var(--blue); }
  .quickstart-profile { margin: 0 0 2.2em; }
  .quickstart-logo-link { display: block; width: 72px; margin: 0 0 0.75em; padding: 0; border-bottom: 0; }
  .quickstart-logo { width: 72px; height: 72px; margin: 0; border-radius: 4px; object-fit: cover; }
  .quickstart-nav { display: flex; flex-wrap: wrap; gap: 0.35em; margin: 0; color: var(--muted); font-size: 0.8em; }
  .quickstart-nav a, .quickstart-nav a:visited { padding: 0; border-bottom: none; color: var(--muted); }
  .quickstart-nav a::after, .quickstart-logo-link::after { content: ''; }
  .quickstart-nav a:hover { color: var(--blue) !important; background: none; }
  .quickstart-hero { padding: 0 0 2.2em; border-bottom: 1px solid var(--line); }
  .quickstart-kicker { margin: 0 0 0.5em; color: var(--blue); font-size: 0.75rem; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; }
  .quickstart-hero h1 { margin: 0 0 0.5em; color: var(--ink); font-size: 2.35rem; line-height: 1.12; letter-spacing: -0.025em; }
  .quickstart-hero > p:not(.quickstart-kicker):not(.quickstart-download-help) { max-width: 35em; margin: 0 0 0.6em; color: var(--muted); font-size: 1.05em; line-height: 1.55; }
  .quickstart-download-help { margin: 0.6em 0 0; color: var(--muted); font-size: 0.82em; }
  .quickstart-steps { list-style: none; padding: 0; margin: 0; }
  .quickstart-step { display: grid; grid-template-columns: 2.2em 1fr; gap: 1em; padding: 2.5em 0; border-bottom: 1px solid var(--line); }
  .step-number { display: grid; width: 1.9em; height: 1.9em; place-items: center; border: 1px solid var(--line); border-radius: 50%; color: var(--blue); font-size: 0.8em; font-weight: 700; }
  .step-copy h2 { margin: 0 0 0.5em; color: var(--ink); font-size: 1.3rem; line-height: 1.25; letter-spacing: -0.015em; }
  .step-copy > p { color: var(--muted); font-size: 1em; line-height: 1.65; }
  .step-copy code, .step-copy kbd { padding: 0.14em 0.35em; border: 1px solid #d8d8d8; border-radius: 4px; background: #f7f7f7; font-size: 0.86em; }
  .setup-screenshot, .setup-visual { box-sizing: border-box; display: block; width: 100%; margin-top: 1.25em; border: 1px solid var(--line); border-radius: 4px; background: #fff; }
  .setup-screenshot { height: auto; padding: 0.8em; }
  .wide-shot { padding: 1em 0.7em; }
  .finder-visual { display: flex; align-items: center; justify-content: center; gap: 2rem; min-height: 13rem; padding: 2rem; background: var(--soft); }
  .file-card { display: grid; gap: 0.65rem; justify-items: center; color: #444; }
  .zip-icon { display: grid; width: 3.6rem; height: 4.3rem; place-items: center; border: 1px solid #bbb; border-radius: 5px; background: #fff; color: #777; font-size: 0.7rem; font-weight: 800; }
  .folder-icon { position: relative; display: block; width: 4.5rem; height: 3.2rem; border-radius: 5px; background: #64a9ff; box-shadow: inset 0 -8px 0 rgba(0,0,0,.05); }
  .folder-icon::before { content: ''; position: absolute; top: -0.48rem; left: 0.25rem; width: 1.8rem; height: 0.7rem; border-radius: 4px 4px 0 0; background: #64a9ff; }
  .folder-icon.large { transform: scale(1.1); }
  .visual-arrow { color: #aaa; font-size: 2rem; }
  .picker-visual { overflow: hidden; }
  .picker-bar { display: flex; align-items: center; gap: 0.5rem; padding: 0.9rem 1rem; border-bottom: 1px solid var(--line); background: #fafafa; }
  .picker-bar span { width: 0.7rem; height: 0.7rem; border-radius: 50%; background: #ddd; }
  .picker-bar strong { margin-left: 0.5rem; font-size: 0.85rem; }
  .picker-body { display: grid; min-height: 9rem; place-items: center; align-content: center; gap: 0.8rem; background: #fff; }
  .picker-footer { display: flex; align-items: center; justify-content: space-between; gap: 1rem; padding: 0.9rem 1rem; border-top: 1px solid var(--line); color: #777; font-size: 0.75rem; }
  .picker-footer button { padding: 0.5rem 0.85rem; border: 0; border-radius: 6px; background: var(--blue); color: #fff; }
  .toolbar-visual { position: relative; min-height: 15rem; padding: 1rem; background: #f2f4f8; }
  .fake-address { margin-right: 3.2rem; padding: 0.6rem 1rem; border-radius: 2rem; background: #fff; color: #777; font-size: 0.8rem; }
  .puzzle { position: absolute; top: 1.5rem; right: 1.6rem; }
  .extension-menu { width: 14rem; margin: 1rem 0 0 auto; padding: 1rem; border-radius: 10px; background: #fff; box-shadow: 0 8px 28px rgba(0,0,0,.14); }
  .extension-menu > div { display: grid; grid-template-columns: 2rem 1fr auto; align-items: center; gap: 0.65rem; margin-top: 1rem; }
  .extension-menu img { width: 2rem; height: 2rem; border-radius: 7px; }
  .pin { color: var(--blue); font-size: 1.25rem; }
  .prism-settings-screenshot { padding: 0; background: #f5f5f4; }
  .privacy-note { padding: 0.8rem 1rem; border-left: 3px solid #9b9b9b; background: var(--soft); font-size: 0.87rem !important; }
  .final-step blockquote { margin: 1.3rem 0; padding: 1rem 1.2rem; border-left: 3px solid var(--blue); background: var(--soft); color: #333; font: 1rem ui-monospace, SFMono-Regular, Menlo, monospace; }
  .back-to-demo { display: inline-block; margin-top: 1rem; }
  .quickstart-footer { padding: 2em 0; color: var(--muted); font-size: 0.9em; }
  .image-credit { font-size: 0.72rem; line-height: 1.5; }
  @media (max-width: 560px) {
    .quickstart-profile { margin-bottom: 1.8em; }
    .quickstart-hero h1 { font-size: 2rem; }
    .quickstart-step { grid-template-columns: 1fr; gap: 1rem; }
    .finder-visual { gap: 1rem; }
  }
</style>
