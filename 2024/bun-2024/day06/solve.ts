import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)

const parseInput = (input: string): string[] => {
  return input.trim().split('\n')
}
const parseLine = (input: string): string[] => {
  return input.split('')
}

const findGuardInLine = (line: string[], y: number): number[] | undefined => {
  const x = line.indexOf('^')
  return x > -1 ? [x, y] : undefined
}

const isInMap = (map: string[][], coord: number[]): boolean => {
  const [y, x] = coord
  return x >= 0 && x < map[0].length && y >= 0 && y < map.length
}

const map = parseInput(await readDay('sample.txt')).map(parseLine)
// const map = parseInput(await readDay()).map(parseLine)

let guardPos = map
  .map((line, y) => findGuardInLine(line, y))
  .filter((coord) => coord !== undefined)[0]
let direction = 'TOP'

const getXY = (map: string[][], x: number, y: number): string => map[y][x]

let nextPosx = 0
let nextPosy = 0
let top = 0

const allPos = new Set<[number, number]>()

while (true) {
  top += 1
  const [x, y] = guardPos // Use standard [x,y] format
  console.log(y + 1, x + 1, getXY(map, x, y), top)

  if (direction === 'TOP') {
    nextPosx = x
    nextPosy = y - 1
  } else if (direction === 'RIGHT') {
    nextPosx = x + 1
    nextPosy = y
  } else if (direction === 'BOTTOM') {
    nextPosx = x
    nextPosy = y + 1
  } else if (direction === 'LEFT') {
    nextPosx = x - 1
    nextPosy = y
  }

  if (!isInMap(map, [nextPosy, nextPosx])) {
    break
  }
  allPos.add([nextPosy, nextPosx])
  if (map[nextPosy][nextPosx] === '#')
    if (direction === 'TOP') {
      direction = 'RIGHT'
      nextPosx = x + 1
      nextPosy = y
    } else if (direction === 'RIGHT') {
      direction = 'BOTTOM'
      nextPosx = x
      nextPosy = y + 1
    } else if (direction === 'BOTTOM') {
      direction = 'LEFT'
      nextPosx = x - 1
      nextPosy = y
    } else if (direction === 'LEFT') {
      direction = 'TOP'
      nextPosx = x
      nextPosy = y - 1
    }
  guardPos = [nextPosx, nextPosy] // Keep [x,y] format

  // if (top > 80) break
}

// console.log(map)

// console.log(getXY(map, 4, 0))
// console.log(getXY(map, 4, 6))

console.log([...allPos].join(' '))
console.log(allPos.size)

function transposeMatrix(matrix: string[][]): string[][] {
  return matrix[0].map((_, colIndex) => matrix.map((row) => row[colIndex]))
}

console.log(transposeMatrix(map))

export const P1 = '-'
export const P2 = '-'
