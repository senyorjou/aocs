import { bold, dim, green, inverse, red } from 'yoctocolors'

import '../helpers/array-extensions'
import { createReader } from '../helpers'

const readDay = createReader(import.meta.dir)
// const contents = await readDay('sample.txt')
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

const isValidSet = (set: CubeSet, reference: CubeSet): boolean => {
  return (
    set.red <= reference.red &&
    set.blue <= reference.blue &&
    set.green <= reference.green
  )
}

const isValidGame = (game: Game, reference: CubeSet): boolean => {
  return game.sets.every((set) => isValidSet(set, reference))
}

const getMaxCubeSet = (game: Game): CubeSet => {
  return game.sets.reduce(
    (max, current) => ({
      red: Math.max(max.red, current.red),
      blue: Math.max(max.blue, current.blue),
      green: Math.max(max.green, current.green),
    }),
    { red: 0, blue: 0, green: 0 },
  )
}

const cubeSetValue = (cubeSet: CubeSet): number =>
  cubeSet.green * cubeSet.red * cubeSet.blue

const reference: CubeSet = {
  red: 12,
  green: 13,
  blue: 14,
}

const P1 = lines
  .map(parseLine)
  .filter((game) => isValidGame(game, reference))
  .map((game) => game.id)
  .sum()

const P2 = lines.map(parseLine).map(getMaxCubeSet).map(cubeSetValue).sum()

console.log(dim('P1:'), inverse(bold(green(`${P1}`))))

console.log(dim('P2:'), inverse(bold(green(`${P1}`))))
