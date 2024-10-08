# frozen_string_literal: true

#
# Copyright (C) 2011 - present Instructure, Inc.
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
#

module Factories
  def page_view_model(opts = {})
    PageView.create!(valid_page_view_attributes.merge(opts))
  end

  def valid_page_view_attributes
    {
      url: "http://www.example.com/courses/1",
      request_id: SecureRandom.uuid,
      user: @user || user_factory
    }
  end

  def page_view_for(opts = {})
    @account = opts[:account] || Account.default
    @context = opts[:context] || @course || course_factory(opts)

    @request_id = opts[:request_id] || SecureRandom.uuid
    Setting.set("enable_page_views", "db")

    @page_view = PageView.new do |p|
      p.assign_attributes({
                            id: @request_id,
                            url: opts[:url] || "http://test.one/",
                            session_id: "phony",
                            context: @context,
                            controller: opts[:controller] || "courses",
                            action: opts[:action] || "show",
                            user_request: true,
                            render_time: 0.01,
                            user_agent: "None",
                            account_id: @account.id,
                            request_id: @request_id,
                            interaction_seconds: 5,
                            user: @user,
                            remote_ip: "192.168.0.42"
                          })
    end
    @page_view.assign_attributes(created_at: opts[:created_at]) if opts[:created_at]
    @page_view.real_user = opts[:real_user] if opts[:real_user]
    if opts[:asset_code] || opts[:asset_category]
      @page_view.build_asset_user_access context: @context,
                                         asset_code: opts[:asset_code],
                                         asset_category: opts[:asset_category]
    end

    @page_view.save!
    @page_view
  end
end
