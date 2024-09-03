import datetime
flag = True
while flag:
    try:
        fecha = input("Ingresa una fecha en el formato DD/MM/AAAA: ")
        datetime.datetime.strptime(fecha, '%d/%m/%Y')
        print("Fecha valida")
        flag = False
    except ValueError:
        print("Fecha invalida")

dia,mes,anio = fecha.split('/')

print('Dia:',dia,'\nMes:',mes,'\nAño:',anio)


