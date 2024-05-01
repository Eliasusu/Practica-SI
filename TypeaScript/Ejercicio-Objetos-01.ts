let grades = [
    { studentId: 66666, grade: 6 },
	{ studentId: 12345, grade: 9 },
	{ studentId: 66666, grade: 8 },
	{ studentId: 12345, grade: 1 },
]

let lenGrades = grades.length

console.log(lenGrades)

let avarage = 0;

let promedios = (registros) =>{
    for(let i = 0; i < lenGrades; i++){
        let student = registros.filter((s) => s.studentId === registros[i].studentId)
        let avarageStudents = [];
        
    }
}

let arrayPrueba = promedios(grades)