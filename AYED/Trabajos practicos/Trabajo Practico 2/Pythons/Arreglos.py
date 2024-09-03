
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
tipoDeProducto = [0, 1, 2, 3, 4, 5, 6, 7], [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(2):
    for c in range(8):
        tipoDeProducto[f][c] = ' '

# ARRAY DE LA LISTA DE PRODUCTOS ELEGIDOS
listaDeProductos = [0, 1, 2]
for f in range(3):
    listaDeProductos[f] = [f],' '


#ARRAY DEL PESO NETO POR CAMION
pesoNetoPorCamion = [0, 1, 2, 3, 4, 5, 6, 7]
for f in range(8):
    pesoNetoPorCamion[f]= 0


def busquedaDeProductos():
    global producto
    global bandera

    posicion = 0
    bandera = False

    while listaDeProductos[posicion] != producto or posicion != 2:
        posicion += 1
    if listaDeProductos[posicion] == producto:
        bandera = True
    else:
        bandera = False
    return(bandera)


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


contadorDeCuposOtorgados = 0
posicion = 0

#ENTREGA DE CUPOS
def entregaDeCupos():
    global contadorDeCuposOtorgados
    global patente
    global bandera

    if contadorDeCuposOtorgados == 4:
        print('Ya no hay cupos disponibles')
    else:
        validacionDePatente()
        busquedaDePatente()
        if bandera == True:
            cupos[0][contadorDeCuposOtorgados] = patente
            cupos[1][contadorDeCuposOtorgados] = 'P'
        else:
            print()
        contadorDeCuposOtorgados += 1


#RECEPCIÓN
def recepcion():
    posicion = 0
    validacionDePatente()
    while cupos[0][posicion] != patente and posicion < 7:
        posicion += 1
    if cupos[1][posicion] == "P":
        cupos[1][posicion] = "E"
    elif cupos[1][posicion] == "E":
        print("La patente que ingresó ya está en proceso")
    else:
        print("La patente que ingresó no tiene cupo, por lo que no se puede recibir")


def registroDePesoBruto():
    validacionDePatente()
    posicion = 0
    while cupos[0][posicion] != patente and posicion < 7:
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


def registroDeTara():
    validacionDePatente()
    t = 0
    while cupos[1][t] != patente and t > 7:
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



def alta():
    global producto
    global bandera

    #La posicion esta en -1 asi no supera el indice del arreglo
    #Las vueltas lo mismo
    opcion = 1
    posicion = -1
    vueltas = -1


    print('Eliga un producto de la siguiente lista:\n- Trigo\n- Maiz\n- Soja\n- Girasol\n- Cebada')

    #Este while deja de iterar lo de adentro cuando la opcion sea = 2 o haya dado 3 vueltas
    while opcion != 2 and vueltas != 2:
        print('Si ingresa un producto debera ser diferente al de esta lista\n', listaDeProductos)
        posicion += 1 
        vueltas += 1
        producto = input(str('Ingrese el producto: '))

        #En este if, estoy comparando con la posicion anterior, sino comparaba con la posicion siguiente
        #y al estar vacia, agregaba el mismo producto
        if listaDeProductos[posicion - 1] != producto:

            #Validación producto
            while len(producto) < 4 or len(producto) > 6:
                producto = input(str('Producto invalido, vuelva a intentarlo: '))

            opcion = int(input('Desea seguir ingresando productos?\n1: Si\n2: No\n'))

            #Validación opción
            while opcion != 1 and opcion != 2:
                opcion = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))

            listaDeProductos[posicion] = [posicion], producto            
        else:
            print('El producto ya fue ingresado, intente nuevamente')

            #Resto la posicion asi el producto que ingrese, quede en la posicion correcta y no en una mas adelante
            posicion -= 1


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



def pesoNetoPorProducto():
    global pesoNeto
    
    for c in range(0,7):
        pesoNetoPorCamion[c] = pesoBrutoYTaraCamion[0][c] - pesoBrutoYTaraCamion[1][c]

    print(pesoNetoPorCamion)



entregaDeCupos()
recepcion()
registroDePesoBruto()
registroDeTara()
pesoNetoPorProducto()