/*
 * Copyright (C) 2025 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import React, {useState, useMemo, type SyntheticEvent} from 'react'
import {Table} from '@instructure/ui-table'
import RosterTableHeader from './RosterTableHeader'
import RosterTableRow from './RosterTableRow'
import {useScope as createI18nScope} from '@canvas/i18n'
import {users} from '../../../util/mocks'

const I18n = createI18nScope('course_people')

const RosterTable = () => {
  const [sortBy, setSortBy] = useState("name")
  const [ascending, setAscending] = useState(true)
  const [selected, setSelected] = useState<Set<string>>(new Set())

  // Mock sorting for testing purposes; to be removed after integration with backend
  const sortedUsers = useMemo(() => {
    if (!sortBy) return users

    const sorted = [...users].sort((a, b) => {
      // @ts-expect-error
      return a[sortBy] > b[sortBy]
        ? 1
        // @ts-expect-error
        : a[sortBy] < b[sortBy]
          ? -1
          : 0
    })

    return ascending ? sorted : sorted.reverse()
  }, [sortBy, ascending])

  const userIds = (users || []).map(user => user.id)

  const handleSort = (_event: SyntheticEvent<Element, Event>, {id}: {id: string}) => {
    if (id === sortBy) {
      setAscending(!ascending)
    } else {
      setSortBy(id)
      setAscending(true)
    }
  }

  const handleSelectAll = (allSelected: boolean) => setSelected(allSelected ? new Set() : new Set(userIds))

  const handleSelectRow = (rowSelected: boolean, userId: string) => {
    const copy = new Set(selected)
    if (rowSelected) {
      copy.delete(userId)
    } else {
      copy.add(userId)
    }
    setSelected(copy)
  }

  const allSelected =
    selected.size > 0 && userIds.every(id => selected.has(id))
  const someSelected = selected.size > 0 && !allSelected
  const direction = ascending ? 'ascending' : 'descending'

  const renderRows = () => (sortedUsers || []).map(user => (
    <RosterTableRow
      key={`user-id-${user.id}`}
      user={user}
      isSelected={selected.has(user.id)}
      handleSelectRow={handleSelectRow}
    />
  ))

  return (
    <Table caption={I18n.t('Course Roster')} data-testid="roster-table">
      <RosterTableHeader
        allSelected={allSelected}
        someSelected={someSelected}
        handleSelectAll={handleSelectAll}
        handleSort={handleSort}
        sortBy={sortBy}
        direction={direction}
      />
      <Table.Body>
        {renderRows()}
      </Table.Body>
    </Table>
  )
}

export default RosterTable
