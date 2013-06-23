require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class Harvest < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => "https://api.harvestapp.com",
        :authorize_url => "/oauth2/authorize",
        :token_url => "/oauth2/token"
      }

      uid { raw_info["user"]["id"] }

      info do
        {
          :name => full_name,
          :email => raw_info["user"]["email"],
          :first_name => raw_info["user"]["first_name"],
          :last_name => raw_info["user"]["last_name"],
          :image => raw_info["user"]["avatar_url"]
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get("/account/who_am_i.json").parsed
      end

      def full_name
        raw_info["user"]["first_name"] + " " + raw_info["user"]["last_name"]
      end
    end
  end
end
