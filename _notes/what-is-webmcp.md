---
title: "What is WebMCP?"
date: 2026-09-03
last_modified_at: 2026-09-03
tags: [ai, agents, web, webmcp]
---

<p class="post-kicker">Web</p>

<p class="post-lede">A native interface for AI agents on the web.</p>

![A Roman bust beside an ASCII desktop computer, representing the web's old interface and its agent-native future]({{ site.baseurl }}/assets/webmcp/cover.jpg)

<p class="post-caption">Cover collage: a public-domain Roman statue by Paolo Neo and a CC0 ASCII computer by Jayvee Enaguas, via <a href="https://commons.wikimedia.org/wiki/File:Statue_roman_emperor.jpg">Wikimedia Commons</a>.</p>

The web is the most important surface for communication and knowledge work today, but it was built with humans as its first-class users. We have designed websites around visual layouts, readable fonts, animations, glimmers, shimmers, and whatnot, while making it harder for bots through CAPTCHAs, rate limits, and other anti-bot measures.

This made sense when “bot” mostly meant a scraper or spammer. But that assumption is changing rapidly as AI agents become capable of completing real tasks on the web.

**How do agents interact with the web today?**

Agents typically observe a page through screenshots, the DOM, or its accessibility tree, and then simulate human actions such as clicking buttons, entering text, and scrolling. This approach is slow and unreliable. A redesigned button, unexpected pop-up, CAPTCHA, or dynamic interface can interrupt the entire workflow. Even simple tasks may require multiple observations, clicks, and retries.

This is the problem WebMCP is trying to solve.

## What is WebMCP

<div class="callout-block" markdown="1">

WebMCP lets developers expose web application functionality—either JavaScript functions or HTML `<form>` elements—as “tools” with natural-language descriptions and structured schemas, designed for AI agent ingestion. These tools can be invoked by AI agents, including those built into the browser, hosted in iframes, or running in extensions to actuate web content that was traditionally designed for human interaction.

[Source](https://github.com/webmachinelearning/webmcp)

</div>

## How does WebMCP work?

WebMCP allows a web page to describe its functionality as a collection of tools that AI agents can discover and invoke.

A tool represents a specific action, such as adding an item to a shopping cart, filtering products, editing a design, or submitting a form. Each tool includes:

- a unique name
- a natural-language description
- a structured input schema
- the JavaScript function that performs the action

For example, a to-do application could expose an `add-todo` tool:

```javascript
await document.modelContext.registerTool({
  name: "add-todo",
  description: "Add a new item to the user's active todo list",
  inputSchema: {
    type: "object",
    properties: {
      text: {
        type: "string",
        description: "The text of the todo item"
      }
    },
    required: ["text"]
  },
  async execute({ text }) {
    await addTodoItem(text);
    return {
      content: [
        {
          type: "text",
          text: `Added "${text}" to the list.`
        }
      ]
    };
  }
});
```

The page registers this tool through `document.modelContext`. An agent connected to the page can then discover the tool, understand when to use it from its description, and provide arguments that match its schema.

### The tool-call lifecycle

A WebMCP interaction follows five main steps:

1. **Registration:** The page exposes one or more tools using JavaScript or supported HTML forms.
2. **Discovery:** The agent discovers the tools currently available on the page.
3. **Invocation:** The agent selects an appropriate tool and sends structured arguments.
4. **Execution:** The browser mediates the request and runs the tool inside the page’s execution context.
5. **Response:** The page returns a result, which the agent uses to continue helping the user.

Consider a user who tells a browser agent:

> Add “Buy groceries” to my to-do list.

The agent discovers the `add-todo` tool and invokes it with:

```json
{
  "text": "Buy groceries"
}
```

The page then runs its existing `addTodoItem()` function. The interface updates immediately, and the result is returned to the agent.

This is the central idea behind WebMCP: the agent does not need to locate an input field, simulate typing, and click a button. It can invoke a well-defined action while the user remains on the same page and can see the result.

### Imperative and declarative tools

WebMCP provides two ways for pages to expose functionality:

- **Imperative tools** expose JavaScript functions through `document.modelContext.registerTool()`. These are useful for dynamic or application-specific operations.
- **Declarative tools** allow browsers to derive tools from HTML forms and their controls.

```html
<form
  toolname="search-cars"
  tooldescription="Search for cars by make and model">
  <input name="make" required>
</form>
```

The imperative API can reuse existing client-side application logic. The declarative API makes common form-based interactions available without requiring every tool to be implemented manually.

### How is this different from MCP?

Traditional MCP integrations usually connect an AI platform directly to a backend server. WebMCP instead exposes functionality from the web page currently open in the browser.

This allows tools to reuse the page’s active state, existing authentication, client-side logic, and visual interface. WebMCP complements backend MCP integrations; it is not intended to replace them or the human-facing web interface.

## WebMCP in action

Consider an e-commerce example of a car marketplace that provides filters for make, model, and maximum price. The website exposes this functionality as a WebMCP tool:

```javascript
await document.modelContext.registerTool({
  name: "search-cars",
  description: "Search available cars by make, model, and price",
  inputSchema: {
    type: "object",
    properties: {
      make: {
        type: "string",
        description: "The vehicle manufacturer"
      },
      model: {
        type: "string",
        description: "The vehicle model"
      },
      maxPrice: {
        type: "number",
        description: "Maximum price in US dollars"
      }
    },
    required: ["make", "model"]
  },

  async execute({ make, model, maxPrice }) {
    const cars = await searchCars({ make, model, maxPrice });

    updateListings(cars);

    return {
      content: [{
        type: "text",
        text: `Found ${cars.length} matching cars.`
      }]
    };
  }
});
```

The user can now ask their browser agent:

> Show me BMW 330i listings under $40,000.

The interaction proceeds as follows:

1. The agent discovers the `search-cars` tool.
2. It determines that the tool matches the user’s request.
3. It extracts the make, model, and maximum price.
4. It invokes the tool with structured arguments:

   ```json
   {
     "make": "BMW",
     "model": "330i",
     "maxPrice": 40000
   }
   ```

5. The page searches for matching cars and updates the visible listings.
6. The tool returns a result that the agent can explain to the user.

The user remains on the marketplace throughout the interaction. They can inspect the results, change the filters, open a listing, or continue working with the agent.

Without WebMCP, an agent might need to inspect the page, locate each filter, simulate several clicks, and determine whether the interface updated correctly. With WebMCP, the website provides a direct, structured path to the same functionality.

The human interface remains useful, but the agent no longer has to operate it like a human.

## Why I’m excited about WebMCP

What excites me about WebMCP is that it does not replace the human web with an agent-only interface. Developers can keep the existing experience while exposing selected functionality to agents. They can reuse client-side logic, work with the page’s current state, and control which tools become available.

If WebMCP succeeds, developers could make many website features agent-friendly without rebuilding them as separate backend integrations. The frontend could become an interface for both humans and agents.

WebMCP is still an evolving proposal, and browser support remains experimental. But it points toward a web where agents no longer have to operate every website by pretending to be human.

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
  .callout-block {
    border-left: 4px solid #93c5fd;
    background: #f8fafc;
    padding: 0.85rem 1rem;
    margin: 1.25rem 0;
    border-radius: 0 6px 6px 0;
  }
  .callout-block p:last-child {
    margin-bottom: 0;
  }
</style>
