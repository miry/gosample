# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class ImporterTest < Minitest::Test
  def setup
    @importer = Distribusion::Importer.new(source: 'foo', passphrase: 'test', logger: setup_logger)
  end

  def test_importer_has_method_import
    assert_includes @importer.methods, :import
  end

  def test_importer_sentinels_parse_csv
    @importer.stub :load, sentinels_routes_csv do
      @importer.import
    end
  end

  private

  def sentinels_routes_csv
    <<~CONTENT
      "route_id", "node", "index", "time"
      "1", "alpha", "0", "2030-12-31T22:00:01+09:00"
      "1", "beta", "1", "2030-12-31T18:00:02+05:00"
      "1", "gamma", "2", "2030-12-31T16:00:03+03:00"
      "2", "delta", "0", "2030-12-31T22:00:02+09:00"
      "2", "beta", "1", "2030-12-31T18:00:03+05:00"
      "2", "gamma", "2", "2030-12-31T16:00:04+03:00"
      "3", "zeta", "0", "2030-12-31T22:00:02+09:00"
    CONTENT
  end
end
