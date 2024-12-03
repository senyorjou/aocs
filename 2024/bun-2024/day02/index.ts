import { bold, dim, green, inverse } from 'yoctocolors'

import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)
// const contents = await readDay('sample.txt')

const parseLine = (line: string): number[] => line.split(' ').map(Number)

const isValidList = (numbers: number[]): boolean => {
  const differences = numbers.slice(1).map((n, i) => n - numbers[i])

  const isIncreasing = differences[0] > 0
  const validDirection = differences.every((d) =>
    isIncreasing ? d > 0 : d < 0,
  )
  const validDifferences = differences.every(
    (d) => Math.abs(d) >= 1 && Math.abs(d) <= 3,
  )

  return validDirection && validDifferences
}

const isAlmostValidList = (numbers: number[]): boolean =>
  numbers.some((_, i) => isValidList(numbers.filter((_, index) => index !== i)))

const numbers = (await readDay()).split('\n').filter(Boolean).map(parseLine)

const validLists = numbers.map(isValidList).filter(Boolean).length
const almostValidLists = numbers.map(isAlmostValidList).filter(Boolean).length

export const P1 = validLists
export const P2 = almostValidLists
