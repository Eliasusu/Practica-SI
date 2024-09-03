remuneracionxhora = 0.00005
operario = input('Ingrese su nombre: ')
for sueldoOperario in range(1,51):
    trabajoxhora = int(input('Ingrese las horas trabajadas en el mes: '))
    sueldo = remuneracionxhora * trabajoxhora
    print('su sueldo en BTC es = ', sueldo)
    