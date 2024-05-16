//const fs = require('node:fs')
import fs from 'node:fs'

function printFileContent(err, data, cb) {
  if (err) {
    console.log(err)
    return
  }
  console.log(data)
  cb()
}

console.log('Start reading a file...')
fs.readFile('./data.txt', { encoding: 'utf8' }, (err, data) =>
  printFileContent(err, data, () => console.log('End of file'))
)
