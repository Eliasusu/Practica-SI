
const identificador = (palabra, conjuntoPalabras) => {

    let palabraEncontrada = conjuntoPalabras.filter((p) => p === palabra);
    let contadorPalabras = palabraEncontrada.length;
    

    return `${contadorPalabras}`
}


let palabras = ['estudiantes', 'probreza', 'peronista', 'bicicleta', 'peronista'];

let a = 'peronista';

let palabrasEncontradas = identificador(a, palabras);

console.log(palabrasEncontradas);

