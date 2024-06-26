/*
 * Copyright (C) 2018 - present Instructure, Inc.
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

import makePromisePool from '../index'

describe('makePromisePool', () => {
  test('makePromisePool respects the pool size', async () => {
    const dataList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    const options = {
      internvalTime: 10,
      poolSize: 2,
    }

    let activeWorkers = 0

    function makePromise() {
      activeWorkers++
      expect(activeWorkers).toBeLessThanOrEqual(options.poolSize)

      return new Promise(resolve => {
        setTimeout(() => {
          expect(activeWorkers).toBeLessThanOrEqual(options.poolSize)
          activeWorkers--
          resolve()
        }, Math.random() * 50)
      })
    }

    await makePromisePool(dataList, makePromise, options)
  })

  test('makePromisePool reports successes and failures correctly', async () => {
    const dataList = [1, 2, 3, 4, 5]
    const options = {
      internvalTime: 100,
      poolSize: 3,
    }

    function makePromise(num) {
      if (num % 2 === 0) {
        return Promise.resolve({})
      } else {
        return Promise.reject('odd number') // eslint-disable-line prefer-promise-reject-errors
      }
    }

    const results = await makePromisePool(dataList, makePromise, options)
    expect(results).toEqual({
      successes: [
        {data: 2, res: {}},
        {data: 4, res: {}},
      ],
      failures: [
        {data: 1, err: 'odd number'},
        {data: 3, err: 'odd number'},
        {data: 5, err: 'odd number'},
      ],
    })
  })
})
