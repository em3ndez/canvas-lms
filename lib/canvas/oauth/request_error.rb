# frozen_string_literal: true

#
# Copyright (C) 2015 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

module Canvas::OAuth
  class RequestError < StandardError
    ERROR_MAP = {
      invalid_client_id: {
        error: :invalid_client,
        error_description: "unknown client",
        http_status: 401
      }.freeze,

      invalid_client_secret: {
        error: :invalid_client,
        error_description: "invalid client",
        http_status: 401
      }.freeze,

      invalid_redirect: {
        error: :invalid_request,
        error_description: "redirect_uri does not match client settings"
      }.freeze,

      invalid_refresh_token: {
        error: :invalid_grant,
        error_description: "refresh_token not found"
      }.freeze,

      invalid_authorization_code: {
        error: :invalid_grant,
        error_description: "authorization_code not found"
      }.freeze,

      incorrect_client: {
        error: :invalid_grant,
        error_description: "incorrect client"
      }.freeze,

      authorization_code_not_supplied: {
        error: :invalid_request,
        error_description: "You must provide the code parameter when using the authorization_code grant type"
      }.freeze,

      refresh_token_not_supplied: {
        error: :invalid_request,
        error_description: "You must provide the refresh_token parameter when using the refresh_token grant type"
      }.freeze,

      unsupported_grant_type: {
        error: :unsupported_grant_type,
        error_description: "The grant_type you requested is not currently supported"
      }.freeze,

      invalid_grant: {
        error: :invalid_grant,
        error_description: "The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client."
      }.freeze
    }.freeze

    def initialize(message)
      super()
      @message = message
    end

    def as_json
      {
        error: error_map[:error],
        error_description: error_map[:error_description]
      }
    end

    def to_render_data
      {
        status: http_status,
        json: as_json
      }
    end

    def http_status
      error_map[:http_status] || 400
    end

    def redirect_uri(url)
      append_error(url)
    end

    private

    def append_error(redirect)
      uri = URI.parse(redirect)
      error_query = URI.decode_www_form(String(uri.query)) << ["error", to_render_data.with_indifferent_access.dig("json", "error")]
      uri.query = URI.encode_www_form(error_query)
      error_description_query = URI.decode_www_form(String(uri.query)) << ["error_description", to_render_data.with_indifferent_access.dig("json", "error_description")]
      uri.query = URI.encode_www_form(error_description_query)
      uri.to_s
    end

    def error_map
      ERROR_MAP[@message]
    end
  end
end
