import http from 'node:http'
import path from 'node:path'
import {appendFile, access} from 'node:fs/promises'

async function registroFecha(destino, contenido){
  try{
    const fs = await appendFile(destino, contenido);
  } catch(err){
    console.log(err)
  }
}

const server = http.createServer((req, res) => {
  console.log('Peticion recibida: ',req.url)
  let fechaHoraPeticion = `${new Date().toISOString()} - ${req.url}\n`
  console.log('Ingresando datos de la peticion...')
  registroFecha('./requests.log', fechaHoraPeticion);

  if(req.url === '/requests.log') {
    res.writeHead(403, { 'Content-Type': 'text/plain' });
    res.end('403 - Forbidden');
    return;
  }

  // let archivo
  // if (req.url === '/' || req.url === '/index' || req.url === '/index.html') {
  //   archivo = path.join('./index.html');
  //   } else {
  //     archivo = path.join(req.url);
  //   }

  // access(archivo, (err) => {
  //   if(!err){
  //     const contentType = getContentType(archivo);
  //     res.writeHead(200, {'Content-Type': contentType});
  //     res.end('Hola')
  //   } else {
  //     res.writeHead(404, { 'Content-Type': 'text/plain' });
  //     res.end('404 - Not Found');
  //   }
  // })
})

function getContentType(filePath) {
    const extname = path.extname(filePath);
    switch (extname) {
        case '.html':
            return 'text/html';
        case '.js':
            return 'text/javascript';
        case '.css':
            return 'text/css';
        default:
            return 'text/plain';
    }
}

server.listen(0, () => {
  console.log(`Server corriendo en -> http://localhost:${server.address().port}`);
});



/* TAREA: Modificar el servidor actual con las siguientes condiciones:
 * responde solo GET (ultimo)
 * responder el archivo de la ruta y manejar errores
 * si es extension html responder con el content-type correcto sino text/plain
 * si no existe el archivo responder con 404 Not Found
 * generar un archivo requests.log donde se almacene la fecha y la ruta de la peticion (mostrar un error por consola si requests.log no existe)
 * evitar que se pueda hacer un request a requests.log
 * devolver status code adecuado SIEMPRE
 * si el path del request es / /index /index.html debe devolver index.html
 * opcional: devolver el favicon
 */
