declare global {
  interface Array<T> {
    sum(this: number[]): number
  }
}

Array.prototype.sum = function (this: number[]) {
  return this.reduce((a, b) => a + b)
}
