# frozen_string_literal: true

#
# Copyright (C) 2018 - present Instructure, Inc.
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

require "active_support"
require "active_support/cache"
require "active_support/version"

module CanvasCache
  module RedisCacheStore
    module ClassMethods
      ActiveSupport::Cache::RedisCacheStore.singleton_class.prepend(self)

      def retrieve_pool_options(_options)
        false
      end

      def build_redis(**redis_options)
        Redis.patch
        return ::Redis::Cluster.new(**redis_options) if redis_options.key?(:nodes)

        super
      end
    end
  end
end
