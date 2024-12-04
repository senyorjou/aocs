import '../helpers/array-extensions'
import { createReader } from '../helpers'

type NumberPair = [number, number]
type Command = 'do()' | "don't()"
type LineItem = NumberPair | Command

const readDay = createReader(import.meta.dir)

const parseSimple = (line: string) => {
  const matches = Array.from(line.matchAll(/mul\((\d+),(\d+)\)/g))
  return matches.map((match) => [match[1], match[2]])
}

const parseComplex = (line: string): LineItem[] => {
  const matches = Array.from(
    line.matchAll(/mul\((\d+),(\d+)\)|(?:don't|do)\(\)/g),
  )
  return matches.map((match) => {
    // numbers
    if (match[1] && match[2]) {
      return [Number(match[1]), Number(match[2])]
    }
    // don't() or do()
    return match[0] as Command
  })
}

const filterDonts = (line: LineItem[]): number => {
  let isProcessable = true
  let sum = 0
  for (const item of line) {
    if (Array.isArray(item) && isProcessable) {
      const [a, b] = item
      sum += a * b
    }
    if (item === 'do()') isProcessable = true
    if (item === "don't()") isProcessable = false
  }
  return sum
}

const input = (await readDay()).replace(/\n/g, '')

export const P1 = parseSimple(input).reduce((sum, [a, b]) => sum + a * b, 0)
export const P2 = filterDonts(parseComplex(input))
