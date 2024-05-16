import { readFile } from 'node:fs/promises'

console.log('Start reading a file...')
readFile('./data.txt', { encoding: 'utf8' })
  .then((data) => console.log(data))
  .then(() => console.log('End of file'))
  .catch((err) => console.log(err))
