---
title: "A Brief History of AI Agents"
date: 2026-04-25
last_modified_at: 2026-04-26
tags: [ai, agents, llm, history, portkey]
---

<p class="post-kicker">Agents</p>

<p class="post-lede">From chat completions API to agent harnesses and everything in between.</p>

![Cover]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/cover-image.jpeg)

---

I work at @PortkeyAI , where my job is to play with the latest AI tools and figure out how they fit into our gateway. Since ChatGPT launched in late 2022, I've watched every abstraction people call an "agent" become outdated within months as models got stronger. Once in a while it's worth stepping back to see how we actually got here.

## Timeline (TL;DR)

- **Part 1** the cognitive revolution - Chat Completions
- **Part 2** models get hands - Function Calling
- **Part 3** models discover autonomy - Agent Loop
- **Part 4** models get a body - Harness
- **Part 5** the outer loop - Ralph Loops

every AI product today is a language model wrapped in scaffolding. the model is a line in a config file. obvious now. wasn't obvious in 2022.

this is five timeline on how we started from chat completions API all the way upto claude code. each part adds one capability the model couldn't do the part before.

*(the pre-LLM history of software orchestration, DAG schedulers, ML pipelines, is covered well in @dexhorthy's 12-factor agents. this post picks up where language models enter the picture.)*

---

## part 1 — the cognitive revolution (2020 – early 2023)

![Part 1 — the cognitive revolution]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-1.jpeg)

## 💡the API — chat completions

for most of its history, a language model was a research artifact. you could read the paper, maybe download the weights if you had the right GPU, run it in a notebook. but you couldn't call it. it lived behind lab doors.

that changed on june 11, 2020, when OpenAI released an API for GPT-3. the announcement was a single paragraph that now reads like a founding stone:

> *We're releasing an API for accessing new AI models developed by OpenAI. Unlike most AI systems which are designed for one use-case, the API today provides a general-purpose "text in, text out" interface, allowing users to try it on virtually any English language task.*

"text in, text out." you sent a prompt, you got a completion back. no memory between calls. no ability to act on the world. one forward pass and done.

the only lever was the prompt itself, and an entire discipline, prompt engineering, grew up around this single knob. few-shot examples, chain-of-thought, role-playing instructions — all attempts to squeeze more capability out of a system that could only read text and write text.

this primitive, the single completion call, never goes away. every part that follows wraps more machinery around it.

## 💡chaining calls

![Part 1.2 — chaining calls]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-1.2.jpeg)

one call wasn't always enough. ask a model to write a blog post in a single prompt and you'd get something unfocused, or wrong in a way that was hard to fix without starting over.

the fix was obvious: break the task into steps. first call generates a plan. second call implements it. third call verifies the output. wire them in order, branch on failure.

harrison chase packaged this in october 2022 with LangChain. ChatGPT launched a month later, millions of developers wanted to build with language models, and LangChain was the fastest on-ramp.

**the developer decides the control flow. the model fills the nodes.**

this is all workflow territory. the first real takeaway: if your task breaks down into steps you can define in advance, a workflow beats an agent almost every time.

---

## Part 2 — models get hands (mid 2023)

![Part 2 — models get hands]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-2.jpeg)

## 💡function calling

everything so far had a limitation so fundamental it was easy to miss: the model could only talk. it couldn't check a database, call an API, run a calculation, or touch the outside world.

on june 13, 2023, OpenAI shipped function calling. Anthropic followed with tool use in early 2024. alongside your prompt, you send a list of tools described as JSON schemas. instead of answering in plain text, the model can reply with a structured call like get_weather(city="mumbai"). your code runs the function, and the result goes back to the model.

thorsten ball has a good way of explaining what this actually is. imagine telling a friend: "in our conversation, wink if you want me to raise my arm." weird instruction, but easy to follow. function calling is the same idea, just formalized. you tell the model what tools exist. when it wants to use one, it winks. you execute. you reply with the result.

under the hood, it's still just text — the model generates a JSON blob instead of a sentence. but conceptually, the model was no longer sealed off. any capability you could wrap in a function became something it could reach for.

most early tool use was single-shot: one function, one result, one response. the model had hands. someone else was still guiding them.

*source: OpenAI — function calling and other API updates*

---

## Part 3 — models discover autonomy (late 2023 – 2024)

![Part 3 — models discover autonomy]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-3.jpeg)

## 💡the agent loop

up to this point, a language model was a tool. you called it, it answered, you decided what to ask next.

the agentic loop inverted this. instead of you deciding the next step, the model decides. call a tool, get the result, feed it back, ask "what now?" repeat until the model says it's done.

fifteen lines. ReAct (yao et al., 2022) formalized the pattern. thorsten ball's how to build an agent proved a working coding agent is about 400 lines once you strip the harness away.

the shift was in who held the steering wheel. before the loop, you drove. after it, the model drove. you built the car, handed over the keys, and told it where to go.

anthropic's *building effective agents* guide drew the line: workflows are systems where the developer orchestrates the control flow. agents are systems where the model directs its own process. the loop is where agents begin. and with that shift came a new failure mode: workflows fail like factories, at a known step you can fix. agents fail like people — they get confused, double down, and you have to trace where the reasoning went sideways.

## 💡the org chart fallacy

once the loop worked, the next idea felt natural: if one agent is good, a team should be better. assign roles — planner, researcher, writer, critic — and wire them like an org chart.

AutoGPT and BabyAGI both launched in march 2023, days after GPT-4. AutoGPT hit the top of GitHub overnight. a whole framework category followed within months: AutoGen, CrewAI, LangGraph, OpenAI Swarm. it felt like the future was a squad of specialized agents collaborating like a high-performing team.

In 1975, brooks' *the Mythical Man-Month* observed that adding people to a late project makes it later — not because the people are bad, but because coordination has a cost. multi-agent systems hit the same wall. handoffs lost information. debugging meant figuring out which agent, on which turn, made the wrong call.

teams shipped multi-agent, then quietly went back to one agent with better tools. the frameworks survived for their plumbing: state machines, checkpointing, observability. the idea wasn't wrong. the shape was. the version that actually works is one boss with disposable interns, not a committee of equals.

## 💡the wall

even a well-built single agent starts losing coherence after ten to fifteen turns. it forgets what it tried, repeats itself, wanders. each turn is maybe 90% reliable; over fifteen turns, your odds of a clean run are about 20%.

longer context windows helped, but didn't solve it. more autonomy wasn't the answer. more structure was.

---

## Part 4 — models get a body (2024 – 2026)

![Part 4 — models get a body]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-4.jpeg)

## 💡the harness

the wall created a design question. the loop worked. tools worked. but pure autonomy degraded fast. what was missing wasn't intelligence. it was structure.

the answer was the harness: every piece of code, configuration, and execution logic that isn't the model itself. system prompt, toolset, loop logic, context management, permissions, feedback mechanisms. **if you're not the model, you're the harness.**

*source: @Vtrivedy10*

the first harnesses that mattered were developer tools. @cursor_ai , @github  Copilot Chat, @cognition's Devin.  they shared a pattern: narrow domain, opinionated tools, a UX that made the agent's actions visible to a human.(code was the natural first domain — it's verifiable and recursively self-improving, what @swyx calls the pareto principle of AGI.)

Claude Code (Anthropic, 2025) became the canonical example. @trq212  shihipar from the team wrote "seeing like an agent": you design tools shaped to the model's abilities, and you learn what those abilities are by watching it work. the tools kept evolving because the assumptions they encoded kept going stale.

sub-agents follow the same logic. the org chart fallacy failed because it used a committee. Claude Code uses a boss with interns: spawn a sub-instance with a clean context and a narrow question, get a summary back, never see the noise. once Claude Code proved the pattern, open-source alternatives followed: OpenCode, Aider, Pi. the harness is a known shape now. what differs is taste.

models today are post-trained with their harness in the loop. @swyx paraphrased McLuhan: *"first the model shapes the harness, then the harness shapes the model."* CompileBench and TerminalBench show the same model scoring very differently across harnesses. every harness component encodes an assumption about what the model can't do, and those assumptions go stale fast.

## 💡the open edge

Claude Code shipped with a fixed toolset. three things opened the edge.

- **MCP** (Model Context Protocol, november 2024) standardized how agents connect to external tools. client-server over JSON-RPC: implement once on each side and they talk. OpenAI and Google adopted it; by december 2025 Anthropic donated it to the Linux Foundation.
- **Skills** (october 2025) are the other half. MCP gives the agent new tools. a skill gives it new knowledge: a SKILL.md that teaches a workflow at runtime. the agent loads context when relevant instead of stuffing everything into the window at startup.
- **Computer use** (october 2024) redefined what a tool can be. screenshot, coordinates, click, type. any GUI becomes a tool surface. slower than a native API, but universally applicable.

the pattern: a stable harness core and an open edge where capabilities plug in from outside. MCP for tools, skills for workflows, computer use for everything else.

---

## Part 5 — the outer loop (2025 and beyond)

![Part 5 — the outer loop]({{ site.baseurl }}/assets/brief-histor-of-ai-agents/part-5.jpeg)

the agent loop let the model decide what to do next. the harness wrapped that loop in structure. the outer loop does the obvious thing: takes the entire harness and puts it back inside a loop.

@GeoffreyHuntley's **ralph wiggum technique** is the simplest version. named after the Simpsons character because it is persistently optimistic and surprisingly effective, ralph is a bash loop:

same prompt every iteration. fresh context every iteration. state doesn't live in the conversation. it lives in the codebase: git commits, test results, a fix_plan.md, an AGENT.md the model updates with what it learns. each iteration reads the current state of the world, picks one thing to do, does it, commits, and exits. the loop restarts with a clean window and a slightly different filesystem.

huntley ran this for three months and built Cursed Lang, a complete programming language with a self-hosting compiler, for a language that didn't exist in the model's training data. dex at HumanLayer tested it for refactoring, leaving it overnight against a coding standards doc. his takeaway: code is cheap. the prompt is what matters.

the same pattern works beyond code. @karpathy's **autoresearch** puts an agent in a loop against a training run: propose a change, evaluate against validation loss, plan the next experiment, repeat. he ran it for two days against a project he'd already hand-tuned extensively. the agent found twenty real improvements he'd missed.

deep research products from Anthropic, OpenAI, and Google are the polished version. ralph builds code. autoresearch tunes models. deep research writes reports. different domains, same primitive: a loop that calls a harness, evaluates the result, and decides whether to keep going.

every layer compensated for a weakness. as models got better, some of it got absorbed. the prompt hacks from 2022 are unnecessary now. the multi-agent frameworks from 2023 already look ornate. the 2025 harness probably will too by 2028.

if you're building today: start with a workflow. reach for the agentic loop only when you need runtime decisions. keep scope narrow. don't add more agents — use the sub-agent pattern. build tools the model can actually use. measure everything. and when the next model ships, remove the outdated patterns.

---

<div class="read-next">
  <p class="read-next-heading"><span>Read next</span></p>
  <ul class="read-next-list">
    <li>
      <a class="read-next-title" href="{{ site.baseurl }}/harness-tax">The Harness Tax: The Dead Weight Inside Your Coding Agent</a>
      <p class="read-next-desc">Claude Code used 83k tokens to write a Fibonacci script. Pi used 8k. Same task. Same output. Here's where the rest of the tokens go — and what the harness is actually costing you.</p>
      <p class="read-next-meta">Agents · Apr 13, 2026</p>
    </li>
    <li>
      <a class="read-next-title" href="{{ site.baseurl }}/llm-pricing">LLM Pricing Is 100x Harder Than You Think</a>
      <p class="read-next-desc">We've tracked $180M in LLM spend across 3,500+ models. Here are the 6 hidden patterns that break cost attribution.</p>
      <p class="read-next-meta">Pricing · Apr 15, 2026</p>
    </li>
  </ul>
</div>

## Further Reading

https://x.com/sambharia/status/2043703343453987133?s=20

https://x.com/sambharia/status/2008784631370498262?s=20

https://x.com/Vtrivedy10/status/2031408954517971368

https://www.humanlayer.dev/blog/12-factor-agents

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
