class Estudiante:
    def __init__(self):
        self.nombre = ''
        self.comision = 0
        self.notas = [0]*3

def main():
    ayed = Estudiante()
    ayed = [None]*1
    for i in range(1):
        ayed[i] = Estudiante()
    cont = 0
    nom = input('Ingrese nombre del alumno: ')
    while nom != '*' and cont < 1:
        ayed[cont].nombre = nom
        ayed[cont].comision = int(input('Ingrese la comision: '))
        for i in range(3):
            ayed[cont].notas[i] = float (input('Ingrese nota: '))
        nom = input('Ingrese nombre del alumno: ')
        cont = cont + 1

    print('Se cargaron ', cont)
    print(ayed.nombre)

main()