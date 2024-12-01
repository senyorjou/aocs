import { bold, dim, green, inverse, red } from 'yoctocolors'

import '../helpers/array-extensions'
import { createReader } from '../helpers'

const numbers: Record<string, string> = {
  one: '1',
  two: '2',
  three: '3',
  four: '4',
  five: '5',
  six: '6',
  seven: '7',
  eight: '8',
  nine: '9',
}

const readDay = createReader(import.meta.dir)
const contents = await readDay()

const lines = contents.split('\n').filter(Boolean)

const findDigits = (line: string): string[] => {
  const digits = line.match(/\d/g)
  return digits ?? []
}

const findNamedDigits = (line: string): string[] => {
  const pattern = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/g
  const matches = [...line.matchAll(pattern)].map((m) => m[1])
  return matches.map((match) => numbers[match] ?? match)
}

const extractPairs = (pairs: string[]): [string, string] => {
  const [first] = pairs
  const last = pairs.at(-1) ?? first
  return [first, last]
}

const extractNums = (pairs: [string, string]): number => {
  const [first, second] = pairs
  return Number.parseInt(first + second)
}

const P1 = lines.map(findDigits).map(extractPairs).map(extractNums).sum()
console.log(dim('P1:'), inverse(bold(green(`${P1}`))))

const P2 = lines.map(findNamedDigits).map(extractPairs).map(extractNums).sum()
console.log(dim('P2:'), inverse(bold(green(`${P1}`))))
