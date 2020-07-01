require 'pact_broker/db'
require 'pact_broker/messages'
require 'pact_broker/repositories/helpers'
require 'pact_broker/versions/latest_version'
require 'pact_broker/domain/label'

module PactBroker
  module Domain
    class result < Sequel::Model
      include Messages

      set_primary_key :id

      

    end
  end
end