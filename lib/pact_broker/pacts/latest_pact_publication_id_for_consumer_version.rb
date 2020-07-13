require 'pact_broker/pacts/all_pact_publications'
require 'pact_broker/repositories/helpers'

module PactBroker
  module Pacts
    class LatestPactPublicationIdForConsumerVersion < Sequel::Model(:latest_pact_publication_ids_for_consumer_versions)
      set_primary_key [:provider_id, :consumer_version_id]
      unrestrict_primary_key
      plugin :upsert, identifying_columns: [:provider_id, :consumer_version_id]

      dataset_module do
        include PactBroker::Repositories::Helpers
      end
    end
  end
end

# Table: latest_pact_publications_by_consumer_versions
# Columns:
#  id                      | integer                     |
#  consumer_id             | integer                     |
#  consumer_name           | text                        |
#  consumer_version_id     | integer                     |
#  consumer_version_number | text                        |
#  consumer_version_order  | integer                     |
#  provider_id             | integer                     |
#  provider_name           | text                        |
#  revision_number         | integer                     |
#  pact_version_id         | integer                     |
#  pact_version_sha        | text                        |
#  created_at              | timestamp without time zone |
