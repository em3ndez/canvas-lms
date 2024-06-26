/*
 * Copyright (C) 2015 - present Instructure, Inc.
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
import ReactDOM from 'react-dom'
import TestUtils from 'react-dom/test-utils'
import $ from 'jquery'
import 'jquery-migrate'
import FilePreviewInfoPanel from '../FilePreviewInfoPanel'
import File from '../../../backbone/models/File'

QUnit.module('File Preview Info Panel Specs', {
  setup() {
    this.file = new File({
      'content-type': 'text/plain',
      size: '1232',
      updated_at: new Date(1431724289),
      user: {
        html_url: 'http://fun.com',
        display_name: 'Jim Bob',
      },
      created_at: new Date(1431724289),
      name: 'some file',
      usage_rights: {
        legal_copyright: 'copycat',
        license_name: 'best license ever',
      },
    })
    this.fPIP = React.createFactory(FilePreviewInfoPanel)
    this.rendered = TestUtils.renderIntoDocument(
      this.fPIP({
        displayedItem: this.file,
        usageRightsRequiredForContext: true,
      })
    )
  },
  teardown() {
    ReactDOM.unmountComponentAtNode(ReactDOM.findDOMNode(this.rendered).parentNode)
    this.file = null
  },
})

test('displays item name', function () {
  equal(this.rendered.refs.displayName.innerText, 'some file', 'rendered the display name')
})

test('displays status', function () {
  equal(this.rendered.refs.status.innerText, 'Published', 'rendered the Status')
})

test('displays content type', function () {
  equal(this.rendered.refs.contentType.innerText, 'Plain text', 'rendered the Kind (content-type)')
})

test('displays size', function () {
  equal(this.rendered.refs.size.innerText, '1 KB', 'rendered size')
})

test('displays date modified', function () {
  equal(
    $(ReactDOM.findDOMNode(this.rendered)).find('#dateModified').find('.visible-desktop').text(),
    'Jan 17, 1970',
    'rendered date modified'
  )
})

test('displays date created', function () {
  equal(
    $(ReactDOM.findDOMNode(this.rendered)).find('#dateCreated').find('.visible-desktop').text(),
    'Jan 17, 1970',
    'rendered date created'
  )
})

test('displays modifed by name with link', function () {
  equal(
    this.rendered.refs.modifedBy.querySelector('a').href,
    'http://fun.com/',
    'make sure its a link to the correct place'
  )
  equal(this.rendered.refs.modifedBy.innerText, 'Jim Bob', 'check that the name was inserted')
})

test('displays legal copy', function () {
  equal(this.rendered.refs.licenseName.innerText, 'best license ever', 'license name')
})

test('displays license name', function () {
  equal(this.rendered.refs.legalCopyright.innerText, 'copycat', 'display the copyright')
})
