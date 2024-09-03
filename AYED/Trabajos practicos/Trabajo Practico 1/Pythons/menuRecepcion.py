def comprobacion():
    promedioTotalsoja = pesoNetoTotalSoja / contadorCamionesSoja
    promedioTotalMaiz = pesoNetoTotalMaiz / contadorCamionesMaiz
    print(contadorDeCamiones)
    print(contadorCamionesSoja)
    print(contadorCamionesMaiz)
    print(pesoNetoTotalMaiz)
    print(pesoNetoTotalSoja)
    print(promedioTotalsoja)
    print(promedioTotalMaiz)
    print()
    print()
    print('Estos son valores de control')

#Menu de recepción 

    print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')

    #Variables globales
    global contadorDeCamiones
    global contadorCamionesSoja
    global contadorCamionesMaiz
    global pesoNetoTotalSoja
    global pesoNetoTotalMaiz

    #Varibles inicializadas
    patente, volver, contadorCamionesSoja, contadorCamionesMaiz, contadorDeCamiones = 0, 0, 0, 0, 0
    pesoBrutoSoja = 0
    pesoBrutoMaiz = 0
    taraSoja = 0
    taraMaiz = 0
    tipoDeProducto = 0
    pesoNetoTotalSoja = 0
    pesoNetoTotalMaiz = 0
    camionMayorSoja = 0

    while not volver == 1:
        contadorDeCamiones += 1
        print('Producto: \n1: Soja \n2: Maíz')
        tipoDeProducto = int(input(''))
        while not tipoDeProducto == 1 and tipoDeProducto != 2:
            print('Producto: \n1: Soja \n2: Maíz')
            tipoDeProducto = int(input(''))
        if tipoDeProducto == 1:
            patente = str(input('Patente: '))
            contadorCamionesSoja += 1   
            pesoBrutoSoja = int(input('Peso Bruto en Kg: '))
            taraSoja = int(input('Tara en Kg: '))
            pesoNetoSoja = pesoBrutoSoja - taraSoja
            pesoNetoTotalSoja += pesoNetoSoja
            x = pesoNetoSoja 
            if x > pesoNetoSoja:
                pesoNetoSojaMayor = pesoNetoSoja
                print(f'Patente: {patente}, Descarga: {pesoNetoSojaMayor}')
            else: 
                print('peso neto', pesoNetoSoja)
            print('Su peso neto es: ', pesoNetoSoja)
            print('¿Desea volver al menu principal? \n 1: Si \n 2: No')
            volver = int(input(''))
            if volver == 1: 
                print('volviendo')
            else: 
                print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')
        else:
            contadorCamionesMaiz += 1
            patente = str(input('Patente: '))
            pesoBrutoMaiz = int(input('Peso Bruto en Kg: '))
            taraMaiz = int(input('Tara en Kg: '))
            pesoNetoMaiz = pesoBrutoMaiz - taraMaiz
            pesoNetoTotalMaiz += pesoNetoMaiz
            print('Su peso neto es: ',pesoNetoMaiz)
            print('¿Desea volver al menu principal? \n 1: Si \n 2: No')
            volver = int(input(''))
            if volver == 1: 
                print('volviendo')
            else: 
                print('Hola! Debera ingresar: \n- Tipo de producto  \n- Numero de patente \n- Peso bruto \n- Tara')
 

