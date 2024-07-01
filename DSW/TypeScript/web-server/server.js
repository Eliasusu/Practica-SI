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

  if(req.url === '/' || req.url === '/index' || req.url === '/index.html'){
    res.writeHead(200, {'Content-Type':'text/html'})
    res.end('Aqui deberia haber un archivo html... deberia')
  } else {
    res.writeHead(404, {'Content-Type':'text/plain'})
    res.end('404 - Not Found')    
  }

})



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
