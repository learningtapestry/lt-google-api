# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/redis_token_store'
require 'googleauth/web_user_authorizer'
require 'signet/errors'

module Lt
  module Google
    module Api
      module Auth
        class Service
          REDIS_PREFIX = 'lt-google-api'

          class << self
            def authorizer_for(callback_path)
              @authorizer_for ||= begin
                client_id =
                  ::Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
                token_store ||= ::Google::Auth::Stores::RedisTokenStore.new(redis: redis)
                scope = %w(https://www.googleapis.com/auth/drive)
                ::Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, callback_path)
              end
            end

            def redis
              Rails.application.config.redis
            end
          end

          attr_reader :context

          def initialize(context, options = {})
            @context = context
            @options = options
          end

          def authorization_url
            authorizer.get_authorization_url @options.merge(request: context.request)
          end

          def authorizer
            self.class.authorizer_for(@options[:callback_path])
          end

          def credentials
            @credentials ||= begin
              remove_expired_token
              authorizer.get_credentials(user_id, context.request)
            end
          rescue StandardError => e
            Rails.logger.warn e.message
            nil
          end

          def user_id
            @user_id ||= "#{REDIS_PREFIX}::#{context.current_user.try(:id)}@#{context.request.remote_ip}"
          end

          private

          def redis
            self.class.redis
          end

          def remove_expired_token
            data = ::JSON.parse(redis.get(user_token)) rescue nil
            return unless data

            expires_at = data['expiration_time_millis'].to_i / 1_000
            return if expires_at.zero?

            redis.del(user_token) if expires_at <= Time.now.to_i
          end

          def user_token
            @user_token ||= "#{REDIS_PREFIX}::#{::Google::Auth::Stores::RedisTokenStore::DEFAULT_KEY_PREFIX}#{user_id}"
          end
        end
      end
    end
  end
end
