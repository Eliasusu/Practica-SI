import os
import pickle
import os.path
import datetime

class Camion:
    def __init__(self):
        self.patente = ' ' #7
        self.codProducto = 0 #4
        self.fechaCupo = ' ' #10
        self.estado = ' ' #1
        self.bruto = 0 #5
        self.tara = 0 #5

class Producto: 
    def __init__(self):
        self.codProducto = 0 #4
        self.nomProducto = ' ' #15
        self.disponibilidad = ' ' #1

class Rubro:
    def __init__(self):
        self.codRubro = 0 #4
        self.nomRubro = ' ' #15

class RubroXProducto:
    def __init__(self):
        self.codRubro = 0 #4
        self.codProducto = 0 #4
        self.valorMinimo = 0.0 #3
        self.valorMaximi = 0.0 #3

class Silos:
    def __init__(self):
        self.codSilos = 0 #4
        self.nomSilos = ' ' #15
        self.codProducto = 0 #4
        self.stock = 0 #5


# ARRAY DE CUPOS
cupos = [0, 1, 2, 3, 4, 5, 6, 7], [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(2):
    for c in range(8):
        cupos[f][c] = ' '

# ARRAY DEL PESO BRUTO
pesoBrutoYTaraCamion = [0, 1, 2, 3, 4, 5, 6, 7], [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(2):
    for c in range(8):
        pesoBrutoYTaraCamion[f][c] = 0

# ARRAY DE TIPO DE PRODUCTO QUE TRAE CADA CAMION
tipoDeProducto = [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(8):
    tipoDeProducto[f] = ' '

# ARRAY DE LA LISTA DE PRODUCTOS ELEGIDOS
listaDeProductos = [0, 1, 2]
for f in range(3):
    listaDeProductos[f] = [f],' '

#ARRAY DEL PESO NETO POR CAMION
pesoNetoPorCamion = [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(8):
    pesoNetoPorCamion[f]= 0

#ARRAY DEL PESO NETO POR PRODUCTO
pesoNetoPorProducto = [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(8):
    pesoNetoPorProducto[f] = 0

#ARRAY DE LA PATENTE PESO NETO
patentePesoNetoPorCamion = [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(8):
    patentePesoNetoPorCamion[f]= ' '



# Procedimientos
global contadorTrigo
global contadorSoja
global contadorMaiz
global contadorGirasol
global contadorCebada

contadorTrigo = 0
contadorSoja = 0
contadorMaiz = 0
contadorGirasol = 0
contadorCebada = 0
contadorDeCuposOtorgados = 0
contadorDeRecibidos = 0
posicion = 0


def contadorDeCamionesPorProducto():
    global contadorTrigo
    global contadorSoja
    global contadorMaiz
    global contadorGirasol
    global contadorCebada

    contadorTrigo = 0
    contadorSoja = 0
    contadorMaiz = 0
    contadorGirasol = 0
    contadorCebada = 0

    for t in range(8):
        if tipoDeProducto[t] == "T":
            contadorTrigo += 1
        elif tipoDeProducto[t] == "S":
            contadorSoja += 1
        elif tipoDeProducto[t] == "M":
            contadorMaiz += 1
        elif tipoDeProducto[t] == "G":
            contadorGirasol += 1
        elif tipoDeProducto[t] == "C":
            contadorCebada += 1
    if contadorTrigo != 0:
        print("- Hay", contadorTrigo, "camiones de Trigo")
    if contadorSoja != 0:
        print("- Hay", contadorSoja, "camiones de Soja")
    if contadorMaiz != 0:
        print("- Hay", contadorMaiz, "camiones de Maiz")
    if contadorGirasol != 0:
        print("- Hay", contadorGirasol, "camiones de Girasol")
    if contadorCebada != 0:
        print("- Hay", contadorCebada, "camiones de Cebada")
    if contadorTrigo == 0 and contadorMaiz == 0 and contadorSoja == 0 and contadorGirasol == 0 and contadorCebada == 0:
        print("- No se ingresaron camiones de ningún producto")


def ordenamientoDeLosPesosNetos():
    auxPesoNeto = 0
    auxPatente = ' '
    auxProducto = ' '

    for x in range(7):
        for y in range(x + 1, 7):
            if pesoNetoPorCamion[x] < pesoNetoPorCamion[y]:
                auxPesoNeto = pesoNetoPorCamion[x]
                pesoNetoPorCamion[x] = pesoNetoPorCamion[y]
                pesoNetoPorCamion[y] = auxPesoNeto

                auxPatente = patentePesoNetoPorCamion[x]
                patentePesoNetoPorCamion[x] = patentePesoNetoPorCamion[y]
                patentePesoNetoPorCamion[y] = auxPatente

                auxProducto = tipoDeProducto[x]
                tipoDeProducto[x] = tipoDeProducto[y]
                tipoDeProducto[y] = auxProducto
    
    print(pesoNetoPorCamion)
    print(patentePesoNetoPorCamion)
    print(tipoDeProducto)


def busquedaDelProductoYPesoNeto():
    global pesoNetoTrigo
    global pesoNetoSoja
    global pesoNetoMaiz
    global pesoNetoGirasol
    global pesoNetoCebada

    pesoNetoTrigo = 0
    pesoNetoSoja = 0
    pesoNetoMaiz = 0 
    pesoNetoGirasol = 0
    pesoNetoCebada = 0



    for t in range(8):
        if tipoDeProducto[t] == "T":
            pesoNetoTrigo += pesoNetoPorCamion[t]
        elif tipoDeProducto[t] == "S":
            pesoNetoSoja += pesoNetoPorCamion[t]
        elif tipoDeProducto[t] == "M":
            pesoNetoMaiz += pesoNetoPorCamion[t]
        elif tipoDeProducto[t] == "G":
            pesoNetoGirasol += pesoNetoPorCamion[t]
        elif tipoDeProducto[t] == "C":
            pesoNetoCebada += pesoNetoPorCamion[t]


def busquedaDeProducto(p):
    global banderaProducto
    print('1')
    print(p)
    banderaProducto = False
    pos = 0
    print(listaDeProductos)
    while listaDeProductos[pos] != p and pos != 2:
        print(listaDeProductos[pos])
        pos += 1
    if listaDeProductos[pos] == p:
        banderaProducto = True
    else:
        banderaProducto = False
    print('2')
    return(banderaProducto)


def ordenamientoPesoNetoMayorPorProducto():
    global pesoNetoMayorTrigo  
    global pesoNetoMayorSoja
    global pesoNetoMayorMaiz
    global pesoNetoMayorGirasol
    global pesoNetoMayorCebada

    global pesoNetoMenorTrigo  
    global pesoNetoMenorSoja 
    global pesoNetoMenorMaiz 
    global pesoNetoMenorGirasol 
    global pesoNetoMenorCebada 
    
    pesoNetoMayorTrigo = 0   
    pesoNetoMayorSoja = 0
    pesoNetoMayorMaiz = 0
    pesoNetoMayorGirasol = 0
    pesoNetoMayorCebada = 0

    pesoNetoMenorTrigo = 0   
    pesoNetoMenorSoja = 0
    pesoNetoMenorMaiz = 0
    pesoNetoMenorGirasol = 0
    pesoNetoMenorCebada = 0

    for x in range(8):
        if tipoDeProducto[x] == "T":
            if pesoNetoPorCamion[x] > pesoNetoMayorTrigo:
                pesoNetoMayorTrigo = pesoNetoPorCamion[x]
            elif pesoNetoPorCamion[x] < pesoNetoMenorTrigo:
                pesoNetoMenorTrigo = pesoNetoPorCamion[x]

        elif tipoDeProducto[x] == "S":
            if pesoNetoPorCamion[x] > pesoNetoMayorSoja:
                pesoNetoMayorSoja = pesoNetoPorCamion[x]
            elif pesoNetoPorCamion[x] < pesoNetoMenorSoja:
                pesoNetoMenorSoja = pesoNetoPorCamion[x]

        elif tipoDeProducto[x] == "M":
            if pesoNetoPorCamion[x] > pesoNetoMayorMaiz:
                pesoNetoMayorMaiz = pesoNetoPorCamion[x]
            elif pesoNetoPorCamion[x] < pesoNetoMenorMaiz:
                pesoNetoMenorMaiz = pesoNetoPorCamion[x]
    
        elif tipoDeProducto[x] == "G":
            if pesoNetoPorCamion[x] > pesoNetoMayorGirasol:
                pesoNetoMayorGirasol = pesoNetoPorCamion[x]
            elif pesoNetoPorCamion[x] < pesoNetoMenorGirasol:
                pesoNetoMenorGirasol = pesoNetoPorCamion[x]
    
        elif tipoDeProducto[x] == "C":
            if pesoNetoPorCamion[x] > pesoNetoMayorCebada:
                pesoNetoMayorCebada = pesoNetoPorCamion[x]
            elif pesoNetoPorCamion[x] < pesoNetoMenorCebada:
                pesoNetoMenorCebada = pesoNetoPorCamion[x]

    print(f'- El peso Neto Mayor de trigo es: {pesoNetoMayorTrigo}')
    print(f'- El peso Neto Menor de trigo es: {pesoNetoMenorTrigo}')
    print(f'- El peso Neto Mayor de Soja es: {pesoNetoMayorSoja}')
    print(f'- El peso Neto Menor de Soja es: {pesoNetoMenorSoja}')
    print(f'- El peso Neto Mayor de Maiz es: {pesoNetoMayorMaiz}')
    print(f'- El peso Neto Menor de Maiz es: {pesoNetoMenorMaiz}')
    print(f'- El peso Neto Mayor de Girasol es: {pesoNetoMayorGirasol}')
    print(f'- El peso Neto Menor de Girasol es: {pesoNetoMenorGirasol}')
    print(f'- El peso Neto Mayor de Cebada es: {pesoNetoMayorCebada}')
    print(f'- El peso Neto Menor de Cebada es: {pesoNetoMenorCebada}')


def alta():
    global producto
    global bandera
    global banderaProducto

    #La posicion esta en -1 asi no supera el indice del arreglo
    #Las vueltas lo mismo
    opcion = 1
    posicion = 0
    vueltas = 0


    print('Eliga un producto de la siguiente lista:\n- Trigo\n- Maiz\n- Soja\n- Girasol\n- Cebada')

    #Este while deja de iterar lo de adentro cuando la opcion sea = 2 o haya dado 3 vueltas
    while opcion != 2 and vueltas != 2:
        print('Si ingresa un producto debera ser diferente al de esta lista\n', listaDeProductos)
        producto = input(str('Ingrese el producto: '))
        print('0')
        busquedaDeProducto(producto)
        #En este if, estoy comparando con la posicion anterior, sino comparaba con la posicion siguiente
        #y al estar vacia, agregaba el mismo producto
        print(banderaProducto)
        if banderaProducto == False:

            #Validación producto
            while len(producto) < 4 or len(producto) > 7:
                producto = input(str('Producto invalido, vuelva a intentarlo: '))

            opcion = int(input('Desea seguir ingresando productos?\n1: Si\n2: No\n'))

            #Validación opción
            while opcion != 1 and opcion != 2:
                opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))

            listaDeProductos[posicion] = [posicion], producto            
        else:
            print('El producto ya fue ingresado, intente nuevamente')
        print(posicion)
        print(vueltas)
            #Resto la posicion asi el producto que ingrese, quede en la posicion correcta y no en una mas adelante
        posicion += 1
        vueltas += 1
        print(posicion)
        print(vueltas)


def baja():

    print('Estos son los productos ingresados\n', listaDeProductos)
    opcionProductoEliminar = int(input('Cual desea eliminar?\nProducto 0\nProducto 1\nProducto 2\n'))
    opcion = 1

    while opcion != 2:
        listaDeProductos[opcionProductoEliminar] = [opcionProductoEliminar],' '
        opcion = int(input('Desea seguir eliminado productos?\n1: Si\n2: No\n'))
            #Validación opción
        while opcion != 1 and opcion != 2:
            opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))  

        print('Ahora estas son las opciones\n', listaDeProductos)


def consulta():

    print('Estos son los productos cargados\n', listaDeProductos)


def modificacion():
    print('Estos son los productos ingresados\n', listaDeProductos)
    opcionProductoEliminar = int(input('Cual desea eliminar?\nProducto 0\nProducto 1\nProducto 2\n'))
    nuevoProducto = str(input('Cual es el nuevo producto que quiere agregar?\n'))
    opcion = 1

    while opcion != 2:
        listaDeProductos[opcionProductoEliminar] = [opcionProductoEliminar],' '
        listaDeProductos[opcionProductoEliminar] = [opcionProductoEliminar], nuevoProducto

        opcion = int(input('Desea seguir eliminado productos?\n1: Si\n2: No\n'))
            #Validación opción
        while opcion != 1 and opcion != 2:
            opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))  

        print('Ahora estas son las opciones\n', listaDeProductos)   


def validacionDePatente():
    global patente

    patente = input(str('ingrese su patente por favor: '))
    while len(patente) != 6 and len(patente) != 7:
        patente = input(str('La patente no es valida, ingrese nuevamente su patente: '))
    
 
    return(patente)


def busquedaDePatente():
    global patente
    global bandera
    global posicion 

    bandera = True

    while cupos[0][posicion] != patente and posicion == 7:
        posicion += 1
    if cupos[0][posicion] == patente:
        print('La patente ya existe')
        bandera = False
    else:
        bandera = True
    return(bandera)


def menuAdministracion():
    print('Bienvenido, estas son las opciones: \n A: Titulares \n B: Productos \n C: Rubros  \n D: Rubros x producto \n E: Silos \n F: Sucursales \n G: Producto por titular \n V: Volver al menu principal')

    # Variable para el menu secundario
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

    # Variable del menu de opciones
    opMenuop = str(input('Elija una opción: ')).upper()

    while opMenuop != 'V':
        while (opMenuop >= 'A' and opMenuop <= 'M'):
            if opMenuop == 'A':
                alta()
            elif opMenuop == 'B':
                baja()
            elif opMenuop == 'C':
                consulta()
            elif opMenuop == 'M':
                modificacion()
            print('\n A: Alta \n B: Baja \n C: Consulta \n M: Modificación \n V: Volver al menú anterior')
            opMenuop = str(input('Elija una opción: ')).upper()


def entregaDeCupos():
    global contadorDeCuposOtorgados
    global patente
    global bandera
    global productoPorCamion

    opcion = 1

    while opcion != 2:
        if contadorDeCuposOtorgados == 8:
            print('Ya no hay cupos disponibles')
        else:
            validacionDePatente()
            busquedaDePatente()
            if bandera == True:
                cupos[0][contadorDeCuposOtorgados] = patente
                cupos[1][contadorDeCuposOtorgados] = 'P'
                patentePesoNetoPorCamion[contadorDeCuposOtorgados] = patente
                print(listaDeProductos)
                productoPorCamion = str(input('Ingrese el tipo de producto disponible, solo con su inicial: '))
                
                while len(productoPorCamion) != 1:
                    productoPorCamion = str(input('Ingrese nuevamente el tipo de producto disponible, solo con su inicial: '))
                
                opcion = int(input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))

            #Validación opción
                while opcion != 1 and opcion != 2:
                    opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))
                tipoDeProducto[contadorDeCuposOtorgados] = productoPorCamion
                contadorDeCuposOtorgados += 1
        print(cupos)
        print(tipoDeProducto)


def menuRecepcion():
    global contadorDeRecibidos
    opcion = 1

    while opcion != 2:
        validacionDePatente()
        posicion = 0
        while cupos[0][posicion] != patente and posicion != 7:
            posicion += 1

        if cupos[1][posicion] == "P":
            contadorDeRecibidos += 1
            cupos[1][posicion] = "E"
        elif cupos[1][posicion] == "E":
            print("La patente que ingresó ya está en proceso")
        else:
            print("La patente que ingresó no tiene cupo, por lo que no se puede recibir")
        print(cupos)

        opcion = int(input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))

        #Validación opción
        while opcion != 1 and opcion != 2:
            opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))
                

def registroDePesoBruto():

    opcion = 1

    while opcion != 2:
        validacionDePatente()
        posicion = 0
        while cupos[0][posicion] != patente and posicion != 7:
            posicion += 1
        if cupos[1][posicion] == "P":
            print("Este camion aún se encuentra pendiente, pase por el menú Recepción")
        elif cupos[1][posicion] == "E":
            if pesoBrutoYTaraCamion[0][posicion] == 0:
                pesoBrutoYTaraCamion[0][posicion] = int(input("ingrese el peso bruto: "))
            else:
                print("esta patente ya tiene registrado un peso bruto")
        else:
            print("El camion no está en proceso, por lo que no se le puede asignar un peso bruto")

        print(cupos)
        print(pesoBrutoYTaraCamion)
        print(tipoDeProducto)
        opcion = int(input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))

        #Validación opción
        while opcion != 1 and opcion != 2:
            opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))


def registroDeTara():

    opcion = 1

    while opcion != 2:
        validacionDePatente()
        t = 0
        while cupos[0][t] != patente and t != 7:
            t = t + 1
        if cupos[1][t] == "P":
            print("Este camion aún se encuentra pendiente, pase por el menú Recepción")
        elif cupos[1][t] == "E":
            if pesoBrutoYTaraCamion[0][t] == 0:
                print("El camion no tiene ingresado un peso bruto, por favor ingrese uno")
            elif pesoBrutoYTaraCamion[1][t] != 0:
                print("El camión ya tiene registrada una Tara")
            elif pesoBrutoYTaraCamion[1][t] == 0:
                pesoBrutoYTaraCamion[1][t] = int(input("ingrese su Tara: "))
        else:
            print("El camion no está en proceso, por lo que no se le puede asignar un peso bruto")

        print(cupos)
        print(pesoBrutoYTaraCamion)
        print(tipoDeProducto)
        opcion = int(input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))

        #Validación opción
        while opcion != 1 and opcion != 2:
            opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))


def pesoNetoPorProductoPorCamion():
    global pesoNeto

    for c in range(8):
        pesoNetoPorCamion[c] = pesoBrutoYTaraCamion[0][c] - pesoBrutoYTaraCamion[1][c]

    ordenamientoDeLosPesosNetos()

    
def menuReportes():
    # Variables globales
    global contadorDeRecibidos
    global contadorDeCuposOtorgados
    global pesoNetoTrigo
    global pesoNetoSoja
    global pesoNetoMaiz
    global pesoNetoGirasol
    global pesoNetoCebada
    global contadorTrigo
    global contadorSoja
    global contadorMaiz
    global contadorGirasol
    global contadorCebada
    


    print(f'- La cantidad de cupos otorgados son: {contadorDeCuposOtorgados}')
    print(f'- La cantidad de camiones recibidos son: {contadorDeRecibidos}')
    contadorDeCamionesPorProducto()
    pesoNetoPorProductoPorCamion()
    busquedaDelProductoYPesoNeto()
    print(f'- El peso neto del Trigo es de: {pesoNetoTrigo}')
    print(f'- El peso neto de la Soja es de: {pesoNetoSoja}')
    print(f'- El peso neto del Maiz es de: {pesoNetoMaiz}')
    print(f'- El peso neto del Girasol es de: {pesoNetoGirasol}')
    print(f'- El peso neto de la Cebada es de: {pesoNetoCebada}')
    
    if contadorTrigo != 0:
        print(f'- El promedio del Trigo por camion es: {pesoNetoTrigo / contadorTrigo}')
    if contadorSoja != 0:
        print(f'- El promedio de la Soja por camion es: {pesoNetoSoja / contadorSoja}')
    if contadorMaiz != 0:
        print(f'- El promedio del Maiz por camion es: {pesoNetoMaiz / contadorMaiz}')
    if contadorGirasol != 0:
        print(f'- El promedio del Girasol por camion es: {pesoNetoGirasol / contadorGirasol}')
    if contadorCebada != 0:
        print(f'- El promedio de la Cebada por camion es: {pesoNetoCebada / contadorCebada}')

    ordenamientoPesoNetoMayorPorProducto()

    print(pesoNetoPorCamion)
    print(patentePesoNetoPorCamion)
    print(tipoDeProducto)


# Opciones del Menu principal
print('Bienvenido al menu principal: \n--- \n1: Administraciones \n2: Entrega de cupos \n3: Recepción \n4: Registro de calidad \n5: Registrar peso bruto \n6: Registrar descarga \n7: Registrar tara \n8: Reportes \n0: Salir')

# Variables inicializadas
opcion = int(input('Elija una opción: '))
while opcion < 0 or opcion > 8:
    opcion = int(input('Elija una opción valida: '))

while opcion != 0:
    while opcion >= 1 and opcion <= 8:
        if opcion == 1:
            menuAdministracion()
        elif opcion == 2:
            entregaDeCupos()
        elif opcion == 3:
            menuRecepcion()
        elif opcion == 4:
            print('Esta opción no ha sido configurada')
        elif opcion == 5:
            registroDePesoBruto()
        elif opcion == 6:
            print('Esta opción no ha sido configurada')
        elif opcion == 7:
            registroDeTara()
        elif opcion == 8:
            menuReportes()

        print('Bienvenido al menu principal: \n--- \n1: Administraciones \n2: Entrega de cupos \n3: Recepción \n4: Registro de calidad \n5: Registrar peso bruto \n6: Registrar descarga \n7: Registrar tara \n8: Reportes \n0: Salir')
        opcion = int(input('Elija una opción: '))
        while opcion < 0 or opcion > 8:
            opcion = int(input('Elija una opción valida: '))

print('Gracias por usar el programa')
