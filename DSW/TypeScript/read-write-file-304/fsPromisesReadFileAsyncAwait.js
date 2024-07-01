import { readFile } from 'node:fs/promises'

try {
  console.log('Start reading a file...')
  const data = await readFile('./data.txt', { encoding: 'utf8' })
  console.log(data)
} catch (err) {
  console.log(err)
} finally {
  console.log('End of file')
}
