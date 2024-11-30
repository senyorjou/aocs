import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)
const contents = await readDay(true)

const lines = contents.split('\n').filter(Boolean)

const findDigits = (line: string): string[] => {
  const digits = line.match(/\d/g)
  return digits ?? []
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

console.log('P1:', P1)
