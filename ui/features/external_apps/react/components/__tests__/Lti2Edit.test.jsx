/*
 * Copyright (C) 2014 - present Instructure, Inc.
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

import React from 'react'
import {createRoot} from 'react-dom/client'
import Lti2Edit from '../Lti2Edit'

const wrapper = document.getElementById('fixtures') || document.createElement('div') // Ensure the element exists
if (!document.getElementById('fixtures')) {
  wrapper.id = 'fixtures'
  document.body.appendChild(wrapper) // Append the div to body if it does not exist
}

const createElement = data => (
  <Lti2Edit
    tool={data.tool}
    handleActivateLti2={data.handleActivateLti2}
    handleDeactivateLti2={data.handleDeactivateLti2}
    handleCancel={data.handleCancel}
  />
)

let root = null

const renderComponent = data => {
  root = createRoot(wrapper)
  root.render(createElement(data))
  return wrapper.firstChild
}

describe('ExternalApps.Lti2Edit', () => {
  afterEach(() => {
    if (root) {
      root.unmount()
      root = null
    }
  })

  test('renders', () => {
    const data = {
      tool: {
        app_id: 3,
        app_type: 'Lti::ToolProxy',
        description: null,
        enabled: false,
        installed_locally: true,
        name: 'SomeTool',
      },
      handleActivateLti2() {},
      handleDeactivateLti2() {},
      handleCancel() {},
    }
    const component = renderComponent(data)
    expect(component).toBeTruthy() // Checks if component has rendered
    expect(component).toBeInstanceOf(HTMLElement) // Check if component is rendered to DOM
  })
})
