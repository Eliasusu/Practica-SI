class Estudiante:
    def __init__(self):
        self.nombre = ''
        self.comision = 0
        self.notas = [0]*3

def main():
    alumno = Estudiante()
    alumno.nombre = input('Ingrese un nombre: ')
    alumno.comision = int(input('Ingrese la comision: '))
    for i in range(3):
        alumno.notas[i] = float(input('Ingrese la nota del parcial: '))
    print('Se cargó exitosamente el alumno', alumno.nombre, 'de la comison', alumno.comision, 'cuyo promedio es', round((alumno.notas[0]+alumno.notas[1]+alumno.notas[2])/3,2))

main()