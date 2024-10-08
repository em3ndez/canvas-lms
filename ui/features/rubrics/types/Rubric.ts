/*
 * Copyright (C) 2023 - present Instructure, Inc.
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

import type {Rubric} from '@canvas/rubrics/react/types/rubric'

export type RubricQueryResponse = {
  rubricsConnection: {
    nodes: Rubric[]
  }
}

export type DeleteRubricQueryResponse = Pick<
  Rubric,
  'id' | 'title' | 'criteria' | 'hidePoints' | 'pointsPossible'
>

export type DuplicateRubricQueryResponse = Pick<
  Rubric,
  'id' | 'title' | 'criteria' | 'hidePoints' | 'pointsPossible'
>

export type archiveRubricResponse = {
  _id: string
  workflowState: string
}

export type RubricImport = {
  attachment: {
    id: string
    filename: string
    size: number
  }
  id: string
  createdAt: string
  errorCount: number
  errorData: {
    message: string
  }[]
  progress: number
  workflowState: string
}
