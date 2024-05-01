let array1 = [0,1,2,3,4,5,6,7,8,9];

console.log(array1);


let lenArray = array1.length - 1

console.log(lenArray)

let array2 = [10];


for(let i=0; i <= lenArray; i++){
    array2[i] = array1[lenArray-i]
}

console.log(array2);