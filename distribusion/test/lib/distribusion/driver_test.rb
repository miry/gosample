# frozen_string_literal: true

require 'test_helper'

class DriverTest < Minitest::Test
  def setup
    @importer = Distribusion::Driver.new(passphrase: 'test', logger: setup_logger)
  end

  def test_importer_has_method_import
    assert_includes @importer.methods, :import_sniffers
    assert_includes @importer.methods, :import_loopholes
  end

  def test_importer_sniffer_parse_csv
    response = {
      'node_times': sniffers_node_times_csv,
      'routes': sniffers_routes_csv,
      'sequences': sniffers_sequences_csv
    }
    @importer.stub :load, response do
      records = @importer.import_sniffers
      assert_equal %i[node_times routes sequences], records.keys
      assert_equal 3, records.size
    end
  end

  def test_importer_loopholes_parse_csv
    response = {
      'node_pairs': loopholes_node_pairs_json,
      'routes': loopholes_routes_json
    }
    @importer.stub :load, response do
      records = @importer.import_loopholes
      assert_equal %i[node_pairs routes], records.keys
    end
  end
end
