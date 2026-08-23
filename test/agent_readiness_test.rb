# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("..", __dir__)

class AgentReadinessTest < Minitest::Test
  def read(path)
    File.read(File.join(ROOT, path), encoding: "UTF-8")
  end

  def test_homepage_retains_original_bio
    homepage = read("_pages/index.md")
    assert_includes homepage, "i'm a generalist doing a mix of product, marketing and engineering."
    refute_includes homepage, "This is the personal website of Siddharth Sambharia"
    refute_includes homepage, "# Siddharth Sambharia"
  end

  def test_not_found_page_has_recovery_links_and_markdown_body
    not_found = read("404.html")
    assert_includes not_found, "permalink: 404.html"
    assert_includes not_found, "/llms.txt"
    assert_includes not_found, "# 404"
  end

  def test_removed_agent_pages_and_api_are_not_present
    %w[_pages/about.md _pages/contact.md _pages/privacy.md _pages/developers.md api/openapi.yaml netlify/functions/health.js].each do |path|
      refute File.exist?(File.join(ROOT, path)), "#{path} should be removed"
    end
    refute_includes read("netlify.toml"), "/api/health"
    refute_includes read("_plugins/llms_txt_generator.rb"), "/developers/"
    refute_includes read("_plugins/llms_txt_generator.rb"), "contact page"
  end

  def test_homepage_schema_has_organization_contact_and_address
    head = read("_includes/head.html")
    assert_includes head, '"@type": "Organization"'
    assert_includes head, '"contactPoint"'
    assert_includes head, '"address": { "@type": "PostalAddress"'
  end
end
