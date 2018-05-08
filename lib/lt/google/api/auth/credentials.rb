# frozen_string_literal: true

module Lt
  module Google
    module Api
      module Auth
        module Credentials
          extend ActiveSupport::Concern

          attr_reader :google_credentials

          def obtain_google_credentials(options = {})
            @google_auth_options = options
            @google_credentials = service.credentials

            redirect_to service.authorization_url unless @google_credentials
          end

          private

          def service
            @service ||= Lt::Google::Api::Auth::Service.new(self, @google_auth_options)
          end
        end
      end
    end
  end
end
