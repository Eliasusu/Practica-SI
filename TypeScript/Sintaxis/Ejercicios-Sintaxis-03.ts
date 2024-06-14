let transformadora = (arrayRaro, tipoDato) => {
    
    let arrayTipoDato = arrayRaro.find((dato) => typeof dato === tipoDato )

    return `${arrayTipoDato}`
}  

let datosLocos = [124, 356, true, 'jonhCena', null];

let dataType = 'string';

let arrayPrueba2 = transformadora(datosLocos, dataType)

console.log(arrayPrueba)
