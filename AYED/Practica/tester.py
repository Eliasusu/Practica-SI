#EJERCICIO 9
# caracter = input('Ingrese su nombre, letra por letra, y cuando finalice agregue un #: ')
# cont = 0
# while caracter != '#':
#     cont += 1
#     caracter = input('Ingrese un nuevo caracter: ')
# cont = cont - 1 
# print(f'Su nombre tiene {cont} caracteres')


#EJERCICIO 13
for aux in range (1,6):
    horasMensuales = int(input('Ingrese las horas trabajadas en el mes: '))
    codigoTrabajador = input('Ingrese su código identificador: ')
    if horasMensuales <= 140:
        montoMenor = int(input('Ingrese el monto menor: '))
        sueldo = montoMenor * horasMensuales
    else: 
        montoMenor = int(input('Ingrese el monto menor: '))
        montoMayor = int(input('ingrese el monto mayor: '))
        horasExtras = horasMensuales - 140
        horasExtras = horasExtras * 1.5 
        sueldo1 = 140 * montoMenor
        sueldo2 = horasExtras * montoMayor
        sueldo = sueldo1 + sueldo2
    if sueldo <= 1000:
        print(f'Trabajador: {codigoTrabajador} Sueldo: {sueldo}$')
    else:
        sueldoExcedente = sueldo - 1000
        sueldoExcedente = sueldoExcedente - (20 * sueldoExcedente / 100)
        sueldo = sueldo + sueldoExcedente
        print(f'Trabajador: {codigoTrabajador} Sueldo: {sueldo}$')
