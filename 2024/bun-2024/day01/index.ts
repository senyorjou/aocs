import { bold, dim, green, inverse } from 'yoctocolors'

import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)
const contents = await readDay()

const lines = contents.split('\n').filter(Boolean)

const parseLines = (line: string) => {
  const [[_, left, right]] = line.matchAll(/(\d+)\s+(\d+)/g)

  return [Number.parseInt(left), Number.parseInt(right)]
}

const pairs = lines.map(parseLines)

const extractAndSort = (pairs: number[][]): [number[], number[]] =>
  [0, 1].map((index) =>
    pairs.map((pair) => pair[index]).sort((a, b) => a - b),
  ) as [number[], number[]]

const calculateDistances = (left: number[], right: number[]): number[] =>
  left.map((value, i) => Math.abs(value - right[i]))

const calculateRelevance = (left: number[], right: number[]): number[] =>
  left.map((value) => right.filter((r) => r === value).length * value)

const [leftElements, rightElements] = extractAndSort(pairs)

export const P1 = calculateDistances(leftElements, rightElements).sum()

export const P2 = calculateRelevance(leftElements, rightElements).sum()
