import { bold, dim, green, inverse, red } from 'yoctocolors'

import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)
const contents = await readDay()

const lines = contents.split('\n').filter(Boolean)

type CubeColor = 'red' | 'blue' | 'green'
type CubeSet = Record<CubeColor, number>
type Game = { id: number; sets: Cubeset[] }

function parseCubeSet(set: string): CubeSet {
  const result: CubeSet = {
    red: 0,
    blue: 0,
    green: 0,
  }

  const pattern = /(\d+) (red|blue|green)/g
  const matches = set.matchAll(pattern)

  for (const match of matches) {
    const [_, count, color] = match
    result[color as CubeColor] = Number.parseInt(count)
  }

  return result
}

const parseLine = (line: string): Game => {
  const [gameIdLine, gamesLine] = line.split(':')

  const gamePattern = /^Game (\d+)$/
  const [_, gameId] = gameIdLine.match(gamePattern) || []

  const games = gamesLine.split(';')
  const cubeSets = games.map(parseCubeSet)
  return {
    id: Number.parseInt(gameId),
    sets: cubeSets,
  }
}

const reference: CubeSet = {
  red: 12,
  green: 13,
  blue: 14,
}

const isValidSetPartial =
  (reference: CubeSet) =>
  (set: CubeSet): boolean =>
    set.red <= reference.red &&
    set.blue <= reference.blue &&
    set.green <= reference.green

const validateSet = isValidSetPartial(reference)
const isValidGame = (game: Game): boolean => game.sets.every(validateSet)

const parsedLines = lines.map(parseLine)

const P1 = parsedLines
  .filter(isValidGame)
  .map(({ id }) => id)
  .sum()

const getMaxCubeSet = (game: Game): CubeSet =>
  game.sets.reduce(
    (max, current) => ({
      red: Math.max(max.red, current.red),
      blue: Math.max(max.blue, current.blue),
      green: Math.max(max.green, current.green),
    }),
    { red: 0, blue: 0, green: 0 },
  )

const cubeSetValue = ({ red, green, blue }: CubeSet): number =>
  red * green * blue

const P2 = parsedLines.map(getMaxCubeSet).map(cubeSetValue).sum()

console.log(dim('P1:'), inverse(bold(green(`${P1}`))))
console.log(dim('P2:'), inverse(bold(green(`${P2}`))))
