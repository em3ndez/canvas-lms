# frozen_string_literal: true

#
# Copyright (C) 2020 - present Instructure, Inc.
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

class Mutations::UpdateOutcomeCalculationMethod < Mutations::OutcomeCalculationMethodBase
  graphql_name "UpdateOutcomeCalculationMethod"

  # input arguments
  argument :calculation_int, Integer, required: false
  argument :calculation_method, String, required: false
  argument :id, ID, required: true

  def resolve(input:)
    record_id = GraphQLHelpers.parse_relay_or_legacy_id(input[:id], "OutcomeCalculationMethod")
    record = OutcomeCalculationMethod.find_by(id: record_id)
    raise GraphQL::ExecutionError, "Unable to find OutcomeCalculationMethod" if record.nil?

    check_permission(record.context)
    upsert(input, existing_record: record)
  end
end
