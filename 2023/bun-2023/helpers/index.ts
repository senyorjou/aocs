const readInput = async (
  callerDir: string,
  fileName = 'input.txt',
): Promise<string> => {
  const file = Bun.file(`${callerDir}/${fileName}`)
  return await file.text()
}

export function createReader(
  callerDir: string,
): (fileName?: string) => Promise<string> {
  return (fileName?) => readInput(callerDir, fileName)
}
