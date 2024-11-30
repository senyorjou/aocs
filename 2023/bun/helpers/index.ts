const readInput = async (
  callerDir: string,
  sample = false,
): Promise<string> => {
  const fileName = sample ? 'input.txt' : 'sample.txt'
  const file = Bun.file(`${callerDir}/${fileName}`)
  return await file.text()
}

export function createReader(
  callerDir: string,
): (sample?: boolean) => Promise<string> {
  return (sample = false) => readInput(callerDir, sample)
}
