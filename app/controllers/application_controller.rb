class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :authenticated_user

  private
    def authenticate_request
        supplied_credentials = request.authorization

        if supplied_credentials.nil?
          render json: "Unauthorized", status: :unauthorized
          return
        end

        supplied_bearer_token = supplied_credentials.split(" ").last

        auth_service_uri = URI.parse(ENV["AUTHENTICATION_API_URL"])
        http = Net::HTTP.new(auth_service_uri.host, auth_service_uri.port)

        verify_authentication_request = Net::HTTP::Get.new(auth_service_uri.request_uri)
        verify_authentication_request["Authorization"] = "Bearer #{supplied_bearer_token}"

        verify_authentication_response = http.request(verify_authentication_request)

        token_valid = verify_authentication_response.code.to_i != 401

        if !token_valid
          render json: "Unauthorized", status: 401
          return
        end

        @authenticated_user =  JSON.parse(verify_authentication_response.body)
    end
end
