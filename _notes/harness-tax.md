---
title: "The Harness Tax: The Dead Weight Inside Your Coding Agent"
date: 2026-04-13
last_modified_at: 2026-04-19
tags: [ai, agents, llm, portkey]
---

<p class="post-kicker">Agents</p>

<p class="post-lede">Claude Code used 83k tokens to write a Fibonacci script. <a href="https://github.com/badlogic/pi-mono?ref=portkey.ai">Pi</a> (<a href="https://openclaw.ai/?ref=portkey.ai">OpenClaw</a>) used 8k. Same task. Same output. Where did the rest of the tokens go? Here's the tax no one's talking about.</p>

![The Harness Tax — same task, same output, 10× the tokens]({{ site.baseurl }}/images/harness-tax-10x-total-tokens.png)

<p class="post-caption">Claude Code used 83k tokens to write a Fibonacci script. Pi (OpenClaw) used 8k. Same task. Same output. Where did the rest of the tokens go? Here's the tax no one's talking about.</p>

[Harnesses are not going away.](https://x.com/hwchase17/status/2042978500567609738?ref=portkey.ai) Even the best models rely on them. Claude Code alone has ~512k lines of harness code. But nobody talks about what that harness actually costs you at inference time.

I wanted to know: when using coding agents, how much of the payload that hits the model is actually my message? And how much is the harness overhead added?

So I pointed three agents at [Portkey's](https://portkey.ai/?ref=portkey.ai) gateway and captured every request — [Pi](https://github.com/badlogic/pi-mono?ref=portkey.ai) (the harness behind [OpenClaw](https://openclaw.ai/?ref=portkey.ai)), [OpenAI Codex](https://openai.com/index/codex/?ref=portkey.ai), and [Claude Code](https://claude.ai/code). Same request and complete token visibility. Then I gave each one the same two messages:

<div class="callout-messages" markdown="0">
  <p>Message 1: hey</p>
  <p>Message 2: write a simple python script to check fibonacci series and save on desktop as agent.py</p>
</div>

Pi sent ~2,600 input tokens. Claude Code sent ~27,000. A 10× spread. Same task. Same model capability. The difference was pure harness overhead.

## The Harness Tax

<div class="tip-callout" markdown="0">
  <p><span class="tip-icon" aria-hidden="true">💡</span> <strong>The Harness Tax</strong> is every token your agent spends on itself before it spends a single token on your task.</p>
</div>

![The Harness Tax — same Fibonacci script, same output, wildly different token costs]({{ site.baseurl }}/images/harness-tax-input-output-bars.png)

You pay this tax before the model does a single unit of useful work. Every agent has one. You never see it unless you look at raw request logs. I routed all three agents through a gateway to get that visibility.

## What Goes Into the Harness Tax?

Every request a coding agent makes to the model carries the full harness payload: tool definitions, system prompt, memory instructions, behavioral routing, and conversation history. All of it. On every turn.

Claude Code's harness costs roughly 27,000 input tokens per request. Codex costs about 15,000. Pi costs about 2,600.

And because the conversation history includes the model's previous responses — which were themselves inflated by verbose tool-call formatting — the payload grows faster than your actual conversation does.

![Per-request input tokens — Pi, OpenAI Codex, and Claude Code]({{ site.baseurl }}/images/harness-tax-per-request-stacked.png)

A real coding session runs 30 to 50 turns. At Claude Code's rate, a 40-turn session burns through 1.12 million input tokens. Roughly half of those are harness overhead.

<div class="tip-callout" markdown="0">
  <p><span class="tip-icon" aria-hidden="true">💡</span> <strong>You pay the harness tax whether you use the tools or not.</strong> The 24 extra tools in Claude Code were defined but never called. Their definitions shipped on every request anyway.</p>
</div>

## Context Rot

The harness tax isn't just a cost problem. It's an attention problem. Every extra token competes with your actual task: your code, your files, your intent.

As the context window fills, the model gets worse at reasoning over the tokens that matter. Every token the harness adds competes for attention against your code, your files, and your actual task. On a complex refactor where the model needs to hold three source files, a test suite, and twenty turns of conversation, 28,000 tokens of framework plumbing aren't sitting idle. They're noise.

<div class="tip-callout" markdown="0">
  <p><span class="tip-icon" aria-hidden="true">💡</span> <strong>A 200k context window carrying 28k tokens of harness overhead isn't a 200k window.</strong> It's a 172k window with worse attention distribution.</p>
</div>

The harness rots in a second way: staleness. Every component encodes an assumption about what the model can't do on its own. Those assumptions go stale fast. More on that below.

## Thin Harness, Fat skills

Pi gives the model four capabilities: read, write, edit a file, and run a shell command. That's the entire tool surface.

The bet is that a model trained on millions of shell sessions, the internet, and GitHub repos already knows how to compose those primitives into anything else. You don't need a dedicated `list_directory` tool when `ls -la` exists. You don't need `search_files` when the model can write `grep -r` on its own.

> *"All frontier models have been RL-trained up the wazoo. They inherently understand what a coding agent is."*
> — Mario Zechner, Pi's creator

[Anthropic's harness engineering team](https://x.com/hwchase17/status/2042978500567609738?ref=portkey.ai) demonstrated this concretely over three model generations. Their coding agent harness for Sonnet 4.5 required context resets because the model would start wrapping up work prematurely as the window filled. Opus 4.5 shipped — resets became unnecessary. Opus 4.6 shipped — they stripped out sprint decomposition entirely, and it still worked better.

Three model generations. Three layers of harness removed. Load-bearing in January, dead weight by March.

> Harnesses encode assumptions that go stale as models improve — [Anthropic Engineering](https://www.anthropic.com/engineering)

An agent has three layers. Complexity should push **up** into the model, which gets better at reasoning, planning, and self-correction with every release. It should push **down** into infrastructure, where routing, governance, observability, and cost controls don't ride along in the context window. The harness in the middle should carry as little as possible.

![Model, harness, and infrastructure — the harness is where the tax lives]({{ site.baseurl }}/images/harness-tax-model-harness-infra-layers.png)

## What This Means

This was a narrow benchmark. Two messages, one trivial task. Claude Code's deep tooling may earn back its overhead on complex work that genuinely exercises those 28 tools.

What this benchmark does show: the overhead exists, it's measurable, and almost nobody is looking at it. For most tasks, the model is carrying 15,000 tokens of framework plumbing it doesn't need. And that overhead is growing slower than models are improving, which means the tax gets harder to justify.

---

Route your agent through [Portkey](https://portkey.ai/?ref=portkey.ai) to measure your own harness tax.

**Further reading:**

- [Mario Zechner's blog post on building Pi](https://github.com/badlogic/pi-mono?ref=portkey.ai) — the design rationale
- [Armin Ronacher: "Pi: The Minimal Agent Within OpenClaw"](https://openclaw.ai/?ref=portkey.ai)
- [Pi on GitHub](https://github.com/badlogic/pi-mono?ref=portkey.ai) · [OpenClaw](https://openclaw.ai/?ref=portkey.ai)

*This article was first published on [X](https://x.com/portkeyai).*


<style>
  .post-kicker {
    font-size: 0.75rem;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: #3b82f6;
    margin: 0 0 0.5rem;
    font-weight: 600;
  }
  .post-lede {
    color: #525252;
    font-size: 1.05em;
    line-height: 1.55;
    margin: 0 0 1.25rem;
  }
  .post-caption {
    font-size: 0.85em;
    font-style: italic;
    color: #737373;
    margin: -0.5rem 0 1.5rem;
    line-height: 1.5;
  }
  .callout-messages {
    background: #faf8f5;
    border: 1px solid #e7e2d9;
    border-radius: 6px;
    padding: 1rem 1.25rem;
    margin: 1.25rem 0;
  }
  .callout-messages p {
    margin: 0 0 0.5rem;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.92em;
    line-height: 1.5;
  }
  .callout-messages p:last-child {
    margin-bottom: 0;
  }
  .tip-callout {
    border-left: 4px solid #93c5fd;
    background: #f8fafc;
    padding: 0.85rem 1rem 0.85rem 1rem;
    margin: 1.25rem 0;
    border-radius: 0 6px 6px 0;
  }
  .tip-callout p {
    margin: 0;
    font-size: 0.95em;
    line-height: 1.55;
  }
  .tip-icon {
    margin-right: 0.25rem;
  }
  .read-next {
    margin-top: 2.5rem;
    padding-top: 1.5rem;
  }
  .read-next-heading {
    display: flex;
    align-items: center;
    gap: 1rem;
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: #404040;
    margin: 0 0 1.25rem;
  }
  .read-next-heading::before,
  .read-next-heading::after {
    content: "";
    flex: 1;
    height: 1px;
    background: #d4d4d4;
  }
  .read-next-heading span {
    white-space: nowrap;
  }
  .read-next-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .read-next-list li {
    margin-bottom: 1.75rem;
  }
  .read-next-list li:last-child {
    margin-bottom: 0;
  }
  .read-next-title {
    font-weight: 700;
    font-size: 1.05em;
    text-decoration: none;
    border-bottom: none;
    padding: 0;
  }
  .read-next-title:hover {
    text-decoration: underline;
  }
  .read-next-desc {
    margin: 0.35rem 0 0.35rem;
    font-size: 0.88em;
    line-height: 1.55;
    color: #404040;
  }
  .read-next-meta {
    margin: 0;
    font-size: 0.68rem;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #737373;
  }
</style>
