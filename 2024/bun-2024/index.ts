import { bold, dim, green, inverse, red } from 'yoctocolors'

const runDay = async (day: string) => {
  try {
    const modulePath = import.meta.resolve(`./day${day}/index.ts`)
    const dayModule = await import(modulePath)

    console.log(dim(`Day ${day} P1:`), inverse(bold(green(`${dayModule.P1}`))))
    console.log(dim(`Day ${day} P2:`), inverse(bold(green(`${dayModule.P2}`))))
  } catch (error) {
    console.error(red(`Day ${day} not found or error running it`))
  }
}

const main = async () => {
  const banner = `
  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
  █  🎄 AOC 2024 SOLUTIONS 🎅  █
  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
  `
  console.log(banner)

  const day = Bun.argv[2]?.padStart(2, '0')

  if (day) {
    await runDay(day)
  } else {
    await runDay('01')
    await runDay('02')
    await runDay('03')
    await runDay('04')
    await runDay('05')
    await runDay('06')
    await runDay('07')
    await runDay('08')
  }
}

main()
