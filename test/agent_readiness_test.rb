# frozen_string_literal: true

require "minitest/autorun"
require "yaml"

ROOT = File.expand_path("..", __dir__)

class AgentReadinessTest < Minitest::Test
  def read(path)
    File.read(File.join(ROOT, path), encoding: "UTF-8")
  end

  def test_homepage_has_server_rendered_heading_and_substantial_copy
    homepage = read("_pages/index.md")
    assert_includes homepage, "# Siddharth Sambharia"
    assert_operator homepage.gsub(/<!--.*?-->/m, "").length, :>, 500
  end

  def test_not_found_page_has_recovery_links_and_markdown_body
    not_found = read("404.html")
    assert_includes not_found, "permalink: 404.html"
    assert_includes not_found, "/llms.txt"
    assert_includes not_found, "# 404"
  end

  def test_trust_and_developer_pages_are_published
    %w[_pages/about.md _pages/contact.md _pages/privacy.md _pages/developers.md].each do |path|
      body = read(path)
      assert_match(/permalink:\s+\//, body)
      assert_operator body.split("---", 3).last.length, :>, 500, path
    end
  end

  def test_openapi_has_operation_ids_and_structured_errors
    spec = YAML.safe_load(read("api/openapi.yaml"))
    operation = spec.dig("paths", "/api/health", "get")
    assert_equal "getSiteHealth", operation["operationId"]
    assert operation["description"].length > 20
    error = spec.dig("components", "schemas", "ErrorResponse", "properties", "error", "properties")
    assert %w[code message resolution].all? { |field| error.key?(field) }
  end

  def test_public_endpoint_returns_json_errors
    function = read("netlify/functions/health.js")
    assert_includes function, "METHOD_NOT_ALLOWED"
    assert_includes function, "application/json; charset=utf-8"
    assert_includes read("netlify.toml"), 'from = "/api/health"'
  end

  def test_accept_variants_are_cache_safe
    assert_includes read("_headers"), "Vary: Accept, Accept-Encoding"
  end

  def test_homepage_schema_has_organization_contact_and_address
    head = read("_includes/head.html")
    assert_includes head, '"@type": "Organization"'
    assert_includes head, '"contactPoint"'
    assert_includes head, '"address": { "@type": "PostalAddress"'
  end
end
