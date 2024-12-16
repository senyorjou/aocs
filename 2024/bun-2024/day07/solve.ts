import '../helpers/array-extensions'
import { createReader } from '../helpers'

type Problem = [number, number[]]
type OperatorFunction = (a: number, b: number) => number
type OperatorMap = {
  '+': OperatorFunction
  '*': OperatorFunction
  '|'?: OperatorFunction
}
type Operator = keyof OperatorMap

const readDay = createReader(import.meta.dir)

const parseInput = (input: string): string[] => {
  return input.trim().split('\n').filter(Boolean)
}

const parseLine = (input: string): [number, number[]] => {
  const [result, numbers] = input.split(':')
  return [
    Number.parseInt(result),
    numbers.split(' ').filter(Boolean).map(Number),
  ]
}

const ops2: OperatorMap = {
  '+': (a: number, b: number) => a + b,
  '*': (a: number, b: number) => a * b,
} as const

const ops3 = {
  '+': (a: number, b: number) => a + b,
  '*': (a: number, b: number) => a * b,
  '|': (a: number, b: number) => Number.parseInt(`${a}${b}`),
}

function generateOps(n: number, operators: OperatorMap): Operator[][] {
  const opKeys = Object.keys(operators) as Operator[]

  // Base case
  if (n === 1) {
    return opKeys.map((op) => [op])
  }

  const results: Operator[][] = []
  const subResults = generateOps(n - 1, operators)

  for (const op of opKeys) {
    for (const subResult of subResults) {
      results.push([op, ...subResult])
    }
  }

  return results
}

function evaluate(
  numbers: number[],
  operations: Operator[],
  operator: OperatorMap,
): number {
  let result = numbers[0]
  for (let i = 0; i < operations.length; i++) {
    // biome-ignore: foo
    result = operator[operations[i]](result, numbers[i + 1])
  }
  return result
}
function solveProblem(
  [target, numbers]: Problem,
  operator: OperatorMap,
): Operator[] | null {
  const operatorCombinations = generateOps(numbers.length - 1, operator)

  for (const operations of operatorCombinations) {
    if (evaluate(numbers, operations, operator) === target) {
      return operations
    }
  }

  return null // No solution found
}

// const equations = parseInput(await readDay('sample.txt')).map(parseLine)
const equations = parseInput(await readDay()).map(parseLine)

let total = 0
for (const [target, numbers] of equations) {
  const solution = solveProblem([target, numbers], ops2)
  if (solution) {
    total += target
  }
}

export const P1 = total

total = 0
for (const [target, numbers] of equations) {
  const solution = solveProblem([target, numbers], ops3)
  if (solution) {
    total += target
  }
}

export const P2 = total
