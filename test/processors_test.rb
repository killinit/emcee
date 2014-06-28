require 'test_helper'
require 'emcee/processors/import_processor'
require 'emcee/processors/script_processor'
require 'emcee/processors/stylesheet_processor'

require 'sass'

# Create a stub of Sprocket's Context class, so we can test if we're 'requiring'
# assets correctly.
class ContextStub
  attr_reader :assets

  def initialize
    @assets = []
  end

  def require_asset(asset)
    @assets << asset
  end

  def evaluate(path, options = {})
    "/* contents */"
  end
end

class ProcessorsTest < ActiveSupport::TestCase
  setup do
    @context = ContextStub.new
    @directory = "/dir"
    @body = %q{
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing imports should work" do
    processor = Emcee::ImportProcessor.new
    processed = processor.process(@context, @body, @directory)

    assert_equal 1, @context.assets.length
    assert_equal "/dir/test.html", @context.assets[0]
    assert_equal processed, %q{
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing stylesheets should work" do
    processor = Emcee::StylesheetProcessor.new
    processed = processor.process(@context, @body, @directory)

    assert_equal processed, %q{
      <link rel="import" href="test.html">
      <style>/* contents */
      </style>
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing scripts should work" do
    processor = Emcee::ScriptProcessor.new
    processed = processor.process(@context, @body, @directory)

    assert_equal processed, %q{
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */
      </script>
      <p>test</p>
    }
  end

  test "processing sass stylesheets should work" do
    @body.gsub!("test.css", "test.css.scss")
    processor = Emcee::StylesheetProcessor.new
    processed = processor.process(@context, @body, @directory)

    assert_equal processed, %q{
      <link rel="import" href="test.html">
      <style>/* contents */
      </style>
      <script src="test.js"></script>
      <p>test</p>
    }
  end
end
