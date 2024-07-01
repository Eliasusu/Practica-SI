import { appendFile } from 'node:fs/promises'



async function ingresoTexto() {
  try {
    const content = 'Toji;Human';
    const fs = await appendFile('./data.txt', content);
  } catch (err) {
    console.log(err);
  }
}

ingresoTexto();
