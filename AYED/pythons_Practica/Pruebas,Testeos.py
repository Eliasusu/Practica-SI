global contDeCartas


class Cartas: 
    def __init__(self):
        self.nombre = ''
        self.email = ''
        self.detalleDelJuguete = ['']*3
        self.codigoDelJuguete = [0]*3

class Juguete:
    def __init__(self):
        self.codigo = 0
        self.nombreDelJuguete = ''
        self.stock = 0
        self.precio = 0
    
pedidos = [Cartas]*200
juguetes = [Juguete]*50

def validarInt(min,max, Dato):

    valor = int(input('Ingrese', Dato,': '))
    while valor <= min or valor >= max:
        valor = int(input('Opción incorrecta, vuelva a intentar: '))

    return(valor)
    
def validarStr(min,max, Dato):

    valorStr = str(input('Ingrese', Dato,' : '))
    while len(valorStr) <= min or len(valorStr) >= max:
        valorStr = str(input('Opción incorrecta, vuelva a intentar: '))
    
    return(valorStr)

def CargaDeJuguetes():
    # i := 1 to 50
    for i in range(3):
        juguetes[i].codigo = int(input('Código: '))
        juguetes[i].nombreDelJuguete = str(input('Nombre: '))
        juguetes[i].stock = int(input('Stock: '))
        juguetes[i].precio = int(input('Precio: '))

def CargaDeCartas():
    global contDeCartas

    nombre = validarStr(18,22, 'Nombre')
    while nombre != '*' and contDeCartas >= 200:
        pedidos[contDeCartas].nombre = nombre
        email = validarStr(43,47, 'Email')
        pedidos[contDeCartas].email = email
        for i in range(3):
            detalle = validarStr(28,32, 'Detalle')
            pedidos[contDeCartas].detalleDelJuguete = detalle
            codigo = validarInt(-1,3, 'Codigo juguete')
            pedidos[contDeCartas].codigoDelJuguete = codigo
        nombre = validarStr(18,22, 'Nombre')
        contDeCartas = contDeCartas + 1

def Busqueda(nombreDeBusqueda):
    global pos

    pos = 0
    while pedidos[pos].nombre != nombreDeBusqueda and pos != contDeCartas:
        pos = pos + 1 
    if pedidos[pos].nombre == nombreDeBusqueda:
        return(pos)
    else:
        pos = 201
        return(pos)

def Disponibilidad():
    nom = validarStr(18,22)
    Busqueda(nom)
    if pos < 200:
        for i in range(3):
            print(nom)
            codJug = pedidos[pos].codigoDelJuguete[i]
            print(f'Para el pedido {pos} el juguete {pedidos[pos].codigoDelJuguete[i]} su precio es ${juguetes[codJug].precio} y su stock es {juguetes[codJug].stock}.')
    else:
        print('No se encontro el pedido')


#Programa Principal
CargaDeJuguetes()

contDeCartas = 0

opcion = validarInt(-1,3)
while opcion != 0:
    if opcion == 1:
        CargaDeCartas()
    elif opcion == 2:
        Disponibilidad()
    elif opcion == 0:
        print('Adios')
        
    opcion = validarInt(-1,3)

        


