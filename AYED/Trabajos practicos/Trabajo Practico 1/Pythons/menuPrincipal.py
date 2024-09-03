#TRABAJO PRACTICO N1 

#Defs
def menuAdministracion():
    print('Bienvenido, estas son las opciones: \n A: Titulares \n B: Productos \n C: Rubros  \n D: Rubros x producto \n E: Silos \n F: Sucursales \n G: Producto por titular \n V: Volver al menu principal')
    
    #Variable para el menu secundario
    op2menu = (input('Elija una opción: ')).upper()  
    
    while op2menu != 'V': 
        while (op2menu >= 'A' and op2menu <= 'G'): 
            if op2menu == 'A':
                menuOpciones()
            elif op2menu == 'B':
                menuOpciones()
            elif op2menu == 'C':
                menuOpciones()
            elif op2menu == 'D':
                menuOpciones()
            elif op2menu == 'E':
                menuOpciones()
            elif op2menu == 'F':
                menuOpciones()
            elif op2menu == 'G':
                menuOpciones()
            print('Bienvenido, estas son las opciones: \n A: Titulares \n B: Productos \n C: Rubros  \n D: Rubros x producto \n E: Silos \n F: Sucursales \n G: Producto por titular \n V: Volver al menu principal')
            op2menu = (input('Elija una opción: ')).upper()

def menuOpciones():
    print('Elija una opción: \n A: Alta \n B: Baja \n C: Consulta \n M: Modificación \n V: Volver al menú anterior')

    #Variable del menu de opciones
    opMenuop = (input('Elija una opción: ')).upper()

    while opMenuop != 'V':
        while (opMenuop >= 'A' and opMenuop <= 'M'):
            if opMenuop == 'A':
                print('Esta opción no ha sido configurada')
            elif opMenuop == 'B':
                print('Esta opción no ha sido configurada')
            elif opMenuop == 'C':
                print('Esta opción no ha sido configurada')
            elif opMenuop == 'M':
                print('Esta opción no ha sido configurada')
            opMenuop = (input('Elija una opción: ')).upper()
            
def menuRecepcion():
    print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')

    #Variables globales
    global contadorCamionesSoja
    global contadorCamionesMaiz
    global pesoNetoTotalSoja
    global pesoNetoTotalMaiz
    global camionMayorSoja
    global camionMenorMaiz
    global patenteCamionMayorSoja
    global patenteCamionMenorMaiz

    #Varibles inicializadas
    patente, volver, contadorCamionesSoja, contadorCamionesMaiz = 0, 0, 0, 0
    pesoBrutoSoja, pesoBrutoMaiz, tara, tipoDeProducto, pesoNetoTotalSoja, pesoNetoTotalMaiz = 0, 0, 0, 0, 0, 0
    camionMayorSoja = 0
    camionMenorMaizBandera = True

    while volver != 1:
        print('Producto: \n1: Soja \n2: Maíz')
        tipoDeProducto = int(input(''))
        while not tipoDeProducto == 1 and tipoDeProducto != 2:
            print('Producto: \n1: Soja \n2: Maíz')
            tipoDeProducto = int(input(''))
        if tipoDeProducto == 1:
            patente = str(input('Patente: '))
            contadorCamionesSoja += 1   
            pesoBrutoSoja = int(input('Peso Bruto en Kg: '))
            tara = int(input('Tara en Kg: '))
            pesoNetoSoja = pesoBrutoSoja - tara
            pesoNetoTotalSoja += pesoNetoSoja
            if pesoNetoSoja > camionMayorSoja:
                camionMayorSoja = pesoNetoSoja
                patenteCamionMayorSoja = patente
            else: 
                print()
            print('Su peso neto es: ', pesoNetoSoja)
            print('¿Desea volver al menu principal? \n 1: Si \n 2: No')
            volver = int(input(''))
            if volver == 1: 
                print()
            else: 
                print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')
        else:
            contadorCamionesMaiz += 1
            patente = str(input('Patente: '))
            pesoBrutoMaiz = int(input('Peso Bruto en Kg: '))
            tara = int(input('Tara en Kg: '))
            pesoNetoMaiz = pesoBrutoMaiz - tara
            pesoNetoTotalMaiz += pesoNetoMaiz
            if camionMenorMaizBandera == True:
                camionMenorMaizBandera = False
                camionMenorMaiz = pesoNetoMaiz
                patenteCamionMenorMaiz = patente
            else:
                if pesoNetoMaiz < camionMenorMaiz:
                    camionMenorMaiz = pesoNetoMaiz
                    patenteCamionMenorMaiz = patente
                else:
                    print()
            print('Su peso neto es: ',pesoNetoMaiz)
            print('¿Desea volver al menu principal? \n 1: Si \n 2: No')
            volver = int(input(''))
            if volver == 1: 
                print()
            else: 
                print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')

def menuReportes():

    #Variables globales
    global contadorCamionesSoja
    global contadorCamionesMaiz
    global pesoNetoTotalSoja
    global pesoNetoTotalMaiz
    global camionMayorSoja
    global camionMenorMaiz
    global patenteCamionMayorSoja
    global patenteCamionMenorMaiz

    promedioTotalsoja = pesoNetoTotalSoja / contadorCamionesSoja
    promedioTotalMaiz = pesoNetoTotalMaiz / contadorCamionesMaiz
    print(f'Cantidad de camiones: {contadorCamionesMaiz + contadorCamionesSoja}')
    print(f'Cantidad de camiones de soja: {contadorCamionesSoja}')
    print(f'Cantidad de camiones de maiz: {contadorCamionesMaiz}')
    print(f'Peso neto total de soja descargado: {pesoNetoTotalSoja}')
    print(f'Peso neto total de maiz descargado: {pesoNetoTotalMaiz}')
    print(f'Promedio total de soja descargada: {promedioTotalsoja}')
    print(f'Promedio total de maiz descargado: {promedioTotalMaiz}')
    print(f'Camion de Soja que mas descargo\n Patente: {patenteCamionMayorSoja}, Descarga: {camionMayorSoja} kg')
    print(f'Camion de Maiz que menos descargo\n Patente: {patenteCamionMenorMaiz}, Descarga: {camionMenorMaiz} kg')

#Opciones del Menu principal
print('Bienvenido al menu principal: \n--- \n1: Administraciones \n2: Entrega de cupos \n3: Recepción \n4: Registro de calidad \n5: Registrar peso bruto \n6: Registrar descarga \n7: Registrar tara \n8: Reportes \n0: Salir')

#Variables inicializadas
opcion = int(input('Elija una opción: '))

while opcion != 0:
    while opcion >= 1 and opcion <= 8:
        if opcion == 1:
            menuAdministracion()
        elif opcion == 2:
            print('Esta opción no ha sido configurada')
        elif opcion == 3:
            menuRecepcion()
        elif opcion == 4:
            print('Esta opción no ha sido configurada')
        elif opcion == 5:
            print('Esta opción no ha sido configurada')
        elif opcion == 6:
            print('Esta opción no ha sido configurada')
        elif opcion == 7:
            print('Esta opción no ha sido configurada')
        elif opcion == 8:
            menuReportes()
        else:
            print('Gracias por usar el programa')

        print('Bienvenido al menu principal: \n--- \n1: Administraciones \n2: Entrega de cupos \n3: Recepción \n4: Registro de calidad \n5: Registrar peso bruto \n6: Registrar descarga \n7: Registrar tara \n8: Reportes \n0: Salir')
        opcion = int(input('Elija una opción: '))

