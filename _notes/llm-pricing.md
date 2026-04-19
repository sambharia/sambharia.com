---
title: "LLM Pricing Is 100x Harder Than You Think"
date: 2026-04-15
last_modified_at: 2026-04-19
---

*This article was first published on [portkey.ai/blog](https://portkey.ai/blog/llm-pricing-2/).*

<p class="post-lede">LLM pricing is surprisingly difficult. We've tracked $180M in LLM spend across 3,500+ models. Here are the 6 hidden patterns that break cost attribution, the architecture we built to solve them, and we're open-sourcing all of it.</p>

Earlier this month, we open-sourced Portkey's [model pricing database](https://github.com/portkey-ai/models) — 3,500+ models across 50+ providers. The same data we use to attribute cost for enterprises processing trillions of tokens through our gateway every day.

Turns out, a lot of teams needed this.

The entire industry is focused on harness design, managed agents, model benchmark scores. Meanwhile, there's no common ground on something more fundamental: **How do you actually attribute cost to model usage?**

Think about it. Most projects maintain an in-house pricing database. A JSON file somewhere in your repo with model names and prices. [OpenCode](https://portkey.ai/blog/the-harness-tax/) has one of these. So does [OpenClaw](https://openclaw.ai/), [LibreChat](https://github.com/danny-avila/librechat), Pi, Theo's T3 code. I keep finding new ones.

The pattern is clear: everyone builds their own thing, it's accurate for a few weeks, then it drifts. There's no canonical source. No API you can just call. No dataset comprehensive enough to handle the weird edge cases.

Three years post-ChatGPT, there's still no standard way to calculate what a single request costs across providers.

At Portkey we've spent three years building the infrastructure for this. Here's everything we've learned, and we're releasing the full stack so you don't have to rebuild it yourself:
- [**Model Data + Free API**](https://github.com/portkey-ai/models): Updated daily at [portkey.ai/models](https://portkey.ai/models)
- [**Portkey's Gateway**](https://github.com/portkey-ai/gateway): Open-source AI gateway with built-in pricing engine

## The 6 patterns that break pricing

These aren't edge cases. Every one of them has caused real cost discrepancies for teams using the models.

### 1. Thinking tokens

Reasoning models like [o3](https://platform.openai.com/docs/models/o3) and [Claude with extended thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking) consume tokens for internal reasoning that never appear in the response. You still get charged for them.

OpenAI's o1-preview has a 4× output-to-input price ratio ($15/M input, $60/M output). Most of that gap is reasoning overhead. If your system only counts visible output tokens, you'll undercount agentic workloads by 30–40%.

### 2. Cache asymmetry

Prompt caching economics are *different* per provider in ways that matter.

Anthropic charges 25% more for cache writes ($3.75/M vs $3.00/M regular input), with reads at $0.30/M. OpenAI charges nothing for writes. Reads get discounted. If you apply a single "cache discount" multiplier across both, your numbers are wrong for at least one of them.

### 3. Context thresholds

OpenAI, Anthropic, and Google all have tiered pricing based on context length. Cross 128K tokens and per-token cost can double. $0.075/M becomes $0.15/M. Nothing in the API response tells you which tier you hit. The request just works. Your cost estimate is silently wrong.

### 4. Same model, different prices

Kimi K2.5 costs $0.5 input / $2.8 output on Together AI, $0.6 input / $3 output on Fireworks. You can't just track "Kimi K2.5." You need "Kimi K2.5 *on Together AI*."

And it gets worse: Bedrock prepends regional prefixes (`us.meta.llama`, `eu.anthropic.claude-...`) that need stripping before you can even look up the price. Azure returns deployment names instead of model identifiers. You need an extra API call to figure out what model you're running.

### 5. Non-token billing

DALL·E 3 bills by image quality and resolution. Video generation charges per second. Realtime audio has separate input/output rates. Embeddings are input-only. Fine-tuning is per-token on some models, per-hour on others. Each needs different fields from the request and maps to a completely different pricing structure.

### 6. New dimensions keep appearing

We started with two billing dimensions: input tokens and output tokens. Now there are over twenty. Web search has per-search pricing. Google's Grounding with Search has its own rate structure. Tool use, code execution — each ships with its own cost model, and new ones appear faster than providers update their documentation.

![LLM pricing complexity — 20+ billing dimensions across 50+ providers]({{ site.baseurl }}/images/llm-pricing-dimensions.png)

## Why it matters

Every enterprise wants to adopt AI. Making it actually work is another story. The moment you move past prototypes, cost attribution becomes a dealbreaker:

- **FinOps goes blind.** Teams running hundreds of model variants across departments need per-team, per-user cost breakdowns. When pricing is wrong, the AI budget becomes a single line item nobody can decompose or optimize.
- **Margins become guesswork.** If you're reselling LLM access — and increasingly everyone is — inaccurate cost data means you're either leaking money or overcharging customers.
- **Budgets can't be enforced.** You can set per-team spending limits, but limits only work if cost data is accurate. A model reporting $0 per request will never trip an alert.
- **Shipping slows down.** Teams get blocked on AI features because nobody can answer "what will this cost at scale?"

## How Portkey's gateway handles this

The gateway normalizes every provider response into a single cost structure. Model identifiers get resolved, usage gets normalized, and cost gets tagged per-team and per-user at the routing layer, before it hits your logs.

Under the hood, the architecture separates three things that change at different rates:

```
Provider Response → Unified Gateway → Pricing Data → Pricing Logic → Cost
```

![Gateway architecture — three layers that change independently]({{ site.baseurl }}/images/llm-pricing-gateway-architecture.png)

![Provider response normalization across 50+ providers]({{ site.baseurl }}/images/llm-pricing-normalization.png)

When a provider changes their response format, we update the extraction. When rates change, we update config. When new dimensions appear, we extend the schema. Each layer changes independently.

The normalization is where most of the complexity lives. Every provider returns usage data differently. OpenAI gives you `prompt_tokens` and `completion_tokens`. Anthropic gives you `input_tokens` and `output_tokens`. Bedrock prepends regional prefixes. Azure returns deployment names. We normalize everything into one structure:

![Normalized token schema — handles 20+ billing dimensions]({{ site.baseurl }}/images/llm-pricing-normalized-tokens.png)

The `additionalUnits` map is what lets us handle new billing dimensions (web search, grounding, tool use) without schema changes. They just become new keys.

Because the gateway sits at the routing layer, it sees every request before it hits your logs. Model identifiers get resolved, usage gets normalized, cost gets tagged. That's what makes per-team and per-user budget limits possible. Cost attribution happens at the source rather than being reconstructed after the fact from incomplete data.

![Per-team and per-user budget attribution in Portkey]({{ site.baseurl }}/images/llm-pricing-budget-attribution.png)

It's worth noting that Stripe recently launched their own AI Gateway specifically for LLM token billing, routing requests through a layer that meters usage per customer, per model, per token type. Same core insight: the centralized proxy is the natural place to solve cost attribution.

## How we keep 3,500+ models accurate

Building the system was the easier part. Keeping it updated across 3,500+ models is the real challenge. Models launch weekly. Pricing changes without changelog entries. Context thresholds get buried in documentation footnotes. No human team can keep up manually.

We built an agent for this using the Claude Agent SDK, with tools for fetching model lists from provider APIs, web scraping, and GitHub integration.

The key design decision: **provider-specific logic lives in skill files, not code.** A skill file is a markdown document describing how to handle a specific provider — where to find model lists, how to scrape pricing, what quirks to watch for. When Anthropic changes something, we update the skill file. Not the agent. Not the codebase.

The agent loads skill files, fetches model lists, scrapes pricing sources, formats everything to schema, and opens PRs with citations. It costs about $2–3 per provider run. Novel pricing structures still confuse it. Humans handle judgment calls. But it covers the tedious work that was eating up our time.

## Pricing complexity isn't slowing down

New models, new billing dimensions, new provider quirks. If your cost dashboards don't match your invoices, this is probably why.

We're releasing everything so you don't have to rebuild it from scratch:
- [**Model Data + Free API**](https://github.com/portkey-ai/models): Updated daily at [portkey.ai/models](https://portkey.ai/models)
- [**Portkey's Gateway**](https://github.com/portkey-ai/gateway): Open-source AI gateway with built-in pricing engine

---




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
</style>
