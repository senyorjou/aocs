import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)

function parseInput(input: string): string[][] {
  return input
    .trim()
    .split('\n')
    .map((line) => line.split(''))
}

function getAllLines(matrix: string[][]) {
  const lines: string[] = []
  const height = matrix.length
  const width = matrix[0].length
  const LINE_LENGTH = 4
  const addLine = (line: string[]) => {
    lines.push(line.join(''))
    lines.push(line.reverse().join(''))
  }
  // Horizontal lines
  for (let i = 0; i < height; i++) {
    for (let j = 0; j <= width - LINE_LENGTH; j++) {
      addLine([
        matrix[i][j],
        matrix[i][j + 1],
        matrix[i][j + 2],
        matrix[i][j + 3],
      ])
    }
  }

  // Vertical lines
  for (let i = 0; i <= height - LINE_LENGTH; i++) {
    for (let j = 0; j < width; j++) {
      addLine([
        matrix[i][j],
        matrix[i + 1][j],
        matrix[i + 2][j],
        matrix[i + 3][j],
      ])
    }
  }

  // Diagonal lines (top-left to bottom-right)
  for (let i = 0; i <= height - LINE_LENGTH; i++) {
    for (let j = 0; j <= width - LINE_LENGTH; j++) {
      addLine([
        matrix[i][j],
        matrix[i + 1][j + 1],
        matrix[i + 2][j + 2],
        matrix[i + 3][j + 3],
      ])
    }
  }

  // Diagonal lines (top-right to bottom-left)
  for (let i = 0; i <= height - LINE_LENGTH; i++) {
    for (let j = width - 1; j >= LINE_LENGTH - 1; j--) {
      addLine([
        matrix[i][j],
        matrix[i + 1][j - 1],
        matrix[i + 2][j - 2],
        matrix[i + 3][j - 3],
      ])
    }
  }

  return lines
}

function findDiagonals(matrix: string[][]): number {
  const height = matrix.length
  const width = matrix[0].length
  const VALID_WORDS = ['MAS', 'SAM']
  let counter = 0

  // Start from 1 trick
  for (let i = 1; i < height - 1; i++) {
    for (let j = 1; j < width - 1; j++) {
      if (matrix[i][j] === 'A') {
        // Get the four corner letters
        const topLeft = matrix[i - 1][j - 1]
        const topRight = matrix[i - 1][j + 1]
        const bottomLeft = matrix[i + 1][j - 1]
        const bottomRight = matrix[i + 1][j + 1]

        const diagonal1 = `${topLeft}A${bottomRight}`
        const diagonal2 = `${bottomLeft}A${topRight}`
        counter += Number(
          VALID_WORDS.includes(diagonal1) && VALID_WORDS.includes(diagonal2),
        )
      }
    }
  }

  return counter
}

// const input = await readDay('sample.txt')
const input = await readDay()
const matrix = parseInput(input)

export const P1 = getAllLines(matrix).filter((w) => w === 'XMAS').length
export const P2 = findDiagonals(matrix)
