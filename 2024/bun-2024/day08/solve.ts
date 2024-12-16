import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)

const parseInput = (input: string): string[] => {
  return input.trim().split('\n')
}
const parseLine = (input: string): string[] => {
  return input.split('')
}

const createIndex = (lines: string[][]): Map => {
  const map = new Map()
  for (const [row, line] of lines.entries()) {
    for (const [col, item] of line.entries()) {
      if (item !== '.') {
        if (map.has(item)) {
          map.set(item, [...map.get(item), [row, col]])
        } else {
          map.set(item, [[row, col]])
        }
      }
    }
  }
  return map
}

const createAnti = ([a, b]: number[], [c, d]: number[]): number[] => [
  c + (c - a) * 2,
  d + (d - b) * 2,
]
const getAllAntis = (pairs: number[][]) =>
  pairs.map(([point1, point2]) => createAnti(point1, point2))

const createAntis = (grid: sting[][], index: Map): Map => {
  for (const [item, positions] of index.entries()) {
    const pairs = positions.flatMap((v1, i) =>
      positions.map((v2, j) => (i !== j ? [v1, v2] : null)).filter((x) => x),
    )
    console.log(getAllAntis(pairs))
  }
}

const getItem = (map: object, row: number, col: number): string => {
  return map[row][col]
}

const grid = parseInput(await readDay('sample.txt')).map(parseLine)
// const equations = parseInput(await readDay()).map(parseLine)

const index = createIndex(grid)

// console.log(grid)
// console.log(index)

createAntis(grid, index)

export const P1 = '-'
export const P2 = '-'
