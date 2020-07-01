require 'sequel'
require 'pact_broker/domain/result'
require 'pact_broker/repositories/helpers'
require 'pact_broker/error'

module PactBroker
  module Pacticipants
    class Repository

      include PactBroker::Repositories::Helpers

      def find_by_id id
        PactBroker::Domain::Result.where(id: id).single_record
      end

      

    end
  end
end