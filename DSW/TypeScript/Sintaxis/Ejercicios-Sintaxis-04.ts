const ingresadora = (array, cadena) => {
    let verificacionCadena = array.find((c) => c === cadena)
    
    if (verificacionCadena === null) {
        array.push(cadena);
        let pos = array.findIndex(cadena)
        return `${pos}`;
    }
    else{
        let pos = array.findIndex(cadena)
        return `${pos}`;
    }
}

let arrayPrueba1 = ['uno','dos','tres','cuatro','cinco','seis'];

let cadenaPrueba = 'uno';

let posDeCadena = ingresadora(arrayPrueba, cadenaPrueba);

console.log('La cadena se encuentra en:', posDeCadena)