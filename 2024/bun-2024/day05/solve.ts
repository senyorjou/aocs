import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)

const parseInput = (input: string): string[] => {
  return input.trim().split('\n\n')
}

const parseOrders = (line: string): [number, number] => {
  const [left, right] = line.split('|')

  return [Number.parseInt(left), Number.parseInt(right)]
}

const partitionUpdates = (updates: number[][], orders: [number, number][]) => {
  const goodMatches: number[][] = []
  const badMatches: number[][] = []

  for (const updateLine of updates) {
    const hasViolation = orders.some(([left, right]) => {
      const matches = updateLine.filter((num) => num === left || num === right)
      if (matches.length === 2) {
        const [updateLeft, updateRight] = matches
        return updateLeft === right && updateRight === left
      }
      return false // if we don't have both numbers, it's not a violation
    })

    if (hasViolation) {
      badMatches.push(updateLine)
    } else {
      goodMatches.push(updateLine)
    }
  }

  return { goodMatches, badMatches }
}

const getMiddleNumber = (line: number[]) => {
  const middleIndex = Math.floor(line.length / 2)
  return line[middleIndex]
}

// const [ordersStr, updatesStr] = parseInput(await readDay('sample.txt'))
const [ordersStr, updatesStr] = parseInput(await readDay())
const orders = ordersStr.split('\n').map(parseOrders)

const updates = updatesStr.split('\n').map((s) => s.split(',').map(Number))

const { goodMatches, badMatches } = partitionUpdates(updates, orders)

const reordered = badMatches.map((updateLine) => {
  const comparator = (a: number, b: number) => {
    const directRule = orders.find(
      ([left, right]) =>
        (left === a && right === b) || (left === b && right === a),
    )
    if (directRule) {
      return directRule[0] === a ? -1 : 1
    }
    return 0
  }
  return [...updateLine].sort(comparator)
})

export const P1 = goodMatches.map(getMiddleNumber).sum()
export const P2 = reordered.map(getMiddleNumber).sum()
