# frozen_string_literal: true

# Auto-generates /llms.txt (and optionally /llms-full.txt) on every build,
# following the spec at https://llmstxt.org.
#
# Zero maintenance: every note in `_notes/` is picked up automatically, sorted
# newest-first. There is nothing to edit when you publish a new post.
#
# Optional config in _config.yml:
#   llms:
#     summary: "One or two sentence blockquote summary."
#     full: true            # also emit /llms-full.txt with full note bodies
#
# Per-note opt-out: add `llms: false` to a note's front matter to exclude it.

require "jekyll"

module LlmsTxt
  class Generator < Jekyll::Generator
    safe true
    priority :lowest

    MAX_DESC = 150

    def generate(site)
      @site = site

      notes = collection_docs(site)
      return if notes.empty?

      add_file(site, "llms.txt", build_index(site, notes))

      if truthy?(site.config.dig("llms", "full"))
        add_file(site, "llms-full.txt", build_full(site, notes))
      end
    end

    private

    def collection_docs(site)
      col = site.collections["notes"]
      return [] unless col

      col.docs
        .reject { |d| d.data["llms"] == false || d.data["published"] == false }
        .sort_by { |d| d.date || Time.at(0) }
        .reverse
    end

    def build_index(site, notes)
      out = +""
      out << "# #{site.config['title']}\n\n"
      out << "> #{summary(site)}\n\n"
      out << "This file helps language models and AI assistants understand and " \
             "cite this site. It lists the site's writing with short descriptions.\n\n"

      out << "## Writing\n\n"
      notes.each do |doc|
        out << "- [#{title(doc)}](#{abs(doc.url)}): #{describe(doc)}\n"
      end
      out << "\n"

      pages = index_pages(site)
      unless pages.empty?
        out << "## Pages\n\n"
        pages.each do |name, url, desc|
          out << "- [#{name}](#{abs(url)}): #{desc}\n"
        end
        out << "\n"
      end

      if truthy?(site.config.dig("llms", "full"))
        out << "## Optional\n\n"
        out << "- [Full content](#{abs('/llms-full.txt')}): every note's full text in one file.\n"
      end

      out
    end

    def build_full(site, notes)
      out = +""
      out << "# #{site.config['title']} — Full Content\n\n"
      out << "> #{summary(site)}\n\n"

      notes.each do |doc|
        out << "# #{title(doc)}\n\n"
        out << "URL: #{abs(doc.url)}\n"
        out << "Published: #{doc.date.strftime('%Y-%m-%d')}\n" if doc.date
        out << "\n"
        out << body_markdown(doc)
        out << "\n\n---\n\n"
      end

      out
    end

    def index_pages(site)
      wanted = { "/" => "About", "/likes" => "Things I like" }
      descriptions = {
        "/" => "Home page — who Siddharth is and what he writes about.",
        "/likes" => "A curated list of talks, books, and films worth revisiting."
      }

      site.pages.filter_map do |page|
        url = page.url
        next unless wanted.key?(url)

        [wanted[url], url, descriptions[url]]
      end
    end

    def summary(site)
      configured = site.config.dig("llms", "summary")
      return squish(configured) if configured && !configured.to_s.strip.empty?

      squish(site.config["description"] || site.config["title"])
    end

    def title(doc)
      doc.data["title"].to_s.strip
    end

    def describe(doc)
      # Only trust an explicit front-matter description; Jekyll's auto-excerpt
      # tends to grab kicker/lede wrapper markup instead of real prose.
      explicit = doc.data["description"]
      return clean(explicit) if explicit && !explicit.to_s.strip.empty?

      text = first_paragraph(doc.content.to_s)
      text.empty? ? title(doc) : text
    end

    # Returns the first substantive paragraph, cleaned to plain text. Skips
    # headings, images, tables, code, hr, blockquotes, kicker/caption wrappers,
    # and cross-post boilerplate so descriptions read like real sentences.
    def first_paragraph(body)
      body.split(/\n\s*\n/).map(&:strip).each do |block|
        next if block.empty?
        next if block.start_with?("#", "---", "```", "|", ">", "![")
        next if block =~ /class=["'](post-kicker|post-caption)/
        next if block =~ /\A\*?This article was first published/i

        cleaned = clean(block)
        return cleaned if cleaned.length >= 40
      end
      ""
    end

    # Best-effort markdown -> readable text for short descriptions.
    def clean(text)
      t = text.to_s.dup
      t.gsub!(%r{</?[^>]+>}, " ")            # html tags
      t.gsub!(/!\[[^\]]*\]\([^)]*\)/, "")     # images
      t.gsub!(/\[([^\]]+)\]\([^)]*\)/, '\1')  # links -> label
      t.gsub!(/[*_`>#]/, "")                  # emphasis / marks
      t = squish(t)
      t = "#{t[0, MAX_DESC].rstrip}…" if t.length > MAX_DESC
      t
    end

    # Full body: strip raw HTML wrappers but keep markdown structure intact.
    def body_markdown(doc)
      squish_blank(doc.content.to_s.gsub(%r{</?p[^>]*>}, "").strip)
    end

    def squish(text)
      text.to_s.gsub(/\s+/, " ").strip
    end

    def squish_blank(text)
      text.to_s.gsub(/\n{3,}/, "\n\n")
    end

    def abs(url)
      "#{base}#{url}"
    end

    def base
      "#{@site.config['url']}#{@site.config['baseurl']}".chomp("/")
    end

    def truthy?(value)
      [true, "true", 1, "1"].include?(value)
    end

    def add_file(site, name, content)
      page = Jekyll::PageWithoutAFile.new(site, site.source, "", name)
      page.data["layout"] = nil
      page.data["sitemap"] = false
      page.data["render_with_liquid"] = false
      page.content = content
      site.pages << page
    end
  end
end
