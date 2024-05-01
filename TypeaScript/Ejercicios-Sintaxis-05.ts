let frase= "Materias aprobadas 0 habiendo rendido 0 veces"

let materiasAprobadas = 0;
let materiasReprobadas = 0;
let cantRendidas = 0;

console.log(frase)
console.log(materiasAprobadas)
console.log(materiasReprobadas)
console.log(cantRendidas)



function aprobar (){
    let materiasApro = materiasAprobadas + 1
    let cantRend = cantRendidas + 1
    return `Materias aprobadas ${materiasApro} habiendo rendido ${cantRend}`
}

function reprobar (){
    let cantRend = cantRendidas + 1
    return `Materias aprobadas ${materiasAprobadas} habiendo rendido ${cantRend}`
}

let mesa1 = aprobar()
materiasAprobadas = 1;
materiasReprobadas = 0;
cantRendidas = 1;



console.log(mesa1)
console.log(materiasAprobadas)
console.log(materiasReprobadas)
console.log(cantRendidas)

let mesa2 = aprobar()
materiasAprobadas = 2;
materiasReprobadas = 0;
cantRendidas = 2;


console.log(mesa2)
console.log(materiasAprobadas)
console.log(materiasReprobadas)
console.log(cantRendidas)

let mesa3 = reprobar()
cantRendidas = 3


console.log(mesa3)
console.log(materiasAprobadas)
console.log(materiasReprobadas)
console.log(cantRendidas)