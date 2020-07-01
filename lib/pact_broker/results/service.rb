require 'pact_broker/repositories'
require 'pact_broker/logging'
require 'pact_broker/messages'
require 'pact_broker/pacticipants/find_potential_duplicate_pacticipant_names'

module PactBroker

  module Pacticipants
    class Service

      extend PactBroker::Repositories
      extend PactBroker::Services
      include PactBroker::Logging

      def self.find_by_id id
        results_repository.find_by_id(id)
      end

    end
  end
end