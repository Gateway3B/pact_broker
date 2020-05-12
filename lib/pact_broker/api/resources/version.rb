require 'pact_broker/services'
require 'pact_broker/api/decorators/version_decorator'
require 'pact_broker/api/resources/base_resource'

module PactBroker
  module Api
    module Resources
      class Version < BaseResource

        def content_types_provided
          [["application/hal+json", :to_json]]
        end

        def content_types_accepted
          [["application/json", :from_json]]
        end

        def allowed_methods
          ["GET", "PATCH", "DELETE", "OPTIONS"]
        end

        def resource_exists?
          version
        end

        def from_json
          parsed_version = Decorators::VersionDecorator.new(@version || PactBroker::Domain::Version.new).from_json(request_body)
          version_service.create_or_update(parsed_version, identifier_from_path[:pacticipant_name])
          to_json
        end

        def to_json
          Decorators::VersionDecorator.new(version).to_json(user_options: decorator_context)
        end

        def delete_resource
          version_service.delete version
          true
        end

        private

        def version
          if path_info[:tag]
            @version ||= version_service.find_by_pacticipant_name_and_latest_tag(path_info[:pacticipant_name], path_info[:tag])
          elsif path_info[:pacticipant_version_number]
            @version ||= version_service.find_by_pacticipant_name_and_number path_info
          else
            @version ||= version_service.find_latest_by_pacticpant_name path_info
          end
        end
      end
    end
  end
end
