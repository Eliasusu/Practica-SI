import datetime
from operator import truediv
import os.path
import pickle
import os



class Camion:
    def __init__(self):
        self.patente = ""  # 7
        self.codProducto = 0  # 4
        self.fecha = ""  # asdasdad
        self.estado = ""  # 1
        self.bruto = 0  # 5
        self.tara = 0  # 5


class Producto:
    def __init__(self):
        self.codProducto = 0  # 4
        self.nomProducto = ""  # 15
        self.disponibilidad = True  # 1


class Rubro:
    def __init__(self):
        self.codRubro = 0  # 4
        self.nomRubro = ""  # 15


class Rubroxproducto:
    def __init__(self):
        self.codRubro = 0  # 4
        self.codProducto = 0  # 4
        self.valMinimo = 0  # 3
        self.valMaximo = 0  # 3


class Silo:
    def __init__(self):
        self.codSilo = 0  # 4
        self.nomSilo = ""  # 15
        self.codProducto = 0  # 4
        self.stock = 0  # 5

# DECLARATIVA DE ARCHIVOS
afOperaciones = "C:\\Users\\Elias\\ayedtp3\\operaciones.dat"
afProductos = "C:\\Users\\Elias\\ayedtp3\\productos.dat"
afRubros = "C:\\Users\\Elias\\ayedtp3\\rubros.dat"
afRubrosxProducto = "C:\\Users\\Elias\\ayedtp3\\rubrosxproductos.dat"
afSilos = "C:\\Users\\Elias\\ayedtp3\\silos.dat"

# Archivo Operaciones
if not os.path.exists(afOperaciones):
    alOperaciones = open(afOperaciones, "w+b")
else:
    alOperaciones = open(afOperaciones, "r+b")

# Archivo Productos
if not os.path.exists(afProductos):
    alProductos = open(afProductos, "w+b")
else:
    alProductos = open(afProductos, "r+b")

# Archivo Rubros
if not os.path.exists(afRubros):
    alRubros = open(afRubros, "w+b")
else:
    alRubros = open(afRubros, "r+b")

# Archivo RubrosxProducto
if not os.path.exists(afRubrosxProducto):
    alRubrosxProducto = open(afRubrosxProducto, "w+b")
else:
    alRubrosxProducto = open(afRubrosxProducto, "r+b")

# Archivo Silos
if not os.path.exists(afSilos):
    alSilos = open(afSilos, "w+b")
else:
    alSilos = open(afSilos, "r+b")



rOperaciones = Camion()
rProductos = Producto()
rRubros = Rubro()
rRubrosxProductos = Rubroxproducto()
rSilos = Silo()


# Opciones menu administración
def menuOpciones():
    os.system('cls')
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
            


# Menu Administración
def menuAdministracion():
    os.system('cls')
    print('Bienvenido, estas son las opciones: \n A: Titulares \n B: Productos \n C: Rubros  \n D: Rubros x producto \n E: Silos \n F: Sucursales \n G: Producto por titular \n V: Volver al menu principal')

    # Variable para el menu secundario
    global op2menu
    op2menu = (input('Elija una opción: ')).upper()

    while op2menu != 'V':
        while (op2menu >= 'A' and op2menu <= 'G'):
            os.system('cls')
            if op2menu == 'A':
                print("Esta funcionalidad está en construcción")
            elif op2menu == 'B':
                menuOpciones()
            elif op2menu == 'C':
                alta()
            elif op2menu == 'D':
                alta()
            elif op2menu == 'E':
                alta()
            elif op2menu == 'F':
                print("Esta funcionalidad está en construcción")
            elif op2menu == 'G':
                print("Esta funcionalidad está en construcción")
            print('Bienvenido, estas son las opciones: \n A: Titulares \n B: Productos \n C: Rubros  \n D: Rubros x producto \n E: Silos \n F: Sucursales \n G: Producto por titular \n V: Volver al menu principal')
            op2menu = (input('Elija una opción: ')).upper()
            


# ALTA
def alta():
    if op2menu == "B":
        altaProductos()
    elif op2menu == "C":
        altaRubros()
    elif op2menu == "D":
        altaRubrosxProd()
    elif op2menu == "E":
        altaSilos()



# FORMATEO
def formatearCamiones(c):
    c.patente = str(c.patente).ljust(7)  # 7
    c.codProducto = str(c.codProducto).ljust(4)  # 4
    c.fecha = str(c.fecha).ljust(10)  # 10
    c.estado = str(c.estado).ljust(1)  # 1
    c.bruto = str(c.bruto).ljust(5)  # 5
    c.tara = str(c.tara).ljust(5)  # 5


def formatearProductos(p):
    p.codProducto = str(p.codProducto).ljust(4)
    p.nomProducto = str(p.nomProducto).ljust(15)


def formatearRubros(rub):
    rub.codRubro = str(rub.codRubro).ljust(4)
    rub.nomRubro = str(rub.nomRubro).ljust(15)


def formatearRXP(rxp):
    rxp.codRubro = str(rxp.codRubro).ljust(4)
    rxp.codProducto = str(rxp.codProducto).ljust(4)
    rxp.valMinimo = str(rxp.valMinimo).ljust(3)
    rxp.valMaximo = str(rxp.valMaximo).ljust(3)


def formatearSilo(s):
    s.codProducto = str(s.codProducto).ljust(4)
    s.codSilo = str(s.codSilo).ljust(4)
    s.nomSilo = str(s.nomSilo).ljust(15)
    s.stock = str(s.stock).ljust(5)


def altaProductos():
    os.system('cls')
    cod = validarNum(1, 9999, "ingrese el código de producto: ")
    x = buscarProducto(cod)
    if x == -1:
        nom = validarString(1, 15, "ingrese el nombre del producto: ")
        grabarProd(cod, nom, os.path.getsize(afProductos))
        print('El producto fue cargado exitosamente')
    else:
        print("el código que ingresó ya existe")

    os.system('pause')



def altaRubros():
    os.system('cls')
    cod = validarNum(0, 9999, "ingrese el código del rubro: ")
    x = buscarRubros(cod)
    if x == - 1:
        nom = validarString(0, 15, "ingrese el nombre del rubro: ")
        grabarRubro(cod, nom, os.path.getsize(afRubros))
        print('El rubro fue cargado exitosamente')
    else:
        print('El codigo de rubro ya fue cargado')
    os.system('pause')


def altaRubrosxProd():
    os.system('cls')
    cod1 = validarNum(0, 9999, "ingrese el código del rubro: ")
    if buscarRubros(cod1) != -1:
        cod2 = validarNum(1, 9999, "ingrese el código de producto: ")
        if buscarProducto(cod2) != -1:
            if buscarRubrosxProducto(cod1, cod2) == -1:
                x = 1
                while x != 0:
                    val1 = validarNum(1, 100, "ingrese el valor mínimo admitido: ")
                    val2 = validarNum(1, 100, "ingrese el valor máximo admitido: ")
                    if val1 > val2:
                        x = 0
                        print("el valor mínimo tiene que ser menor al máximo")
                    else:
                        x = 0
                        grabarRubroxProd(cod1, cod2, val1, val2, os.path.getsize(afRubrosxProducto))
            else:
                print('El rubro ya está cargado')
    else:
        print("el código de rubro no existe")


def altaSilos():
    os.system('cls')
    codP = validarNum(1, 9999, "ingrese el código de producto: ")
    if buscarProducto(codP) != -1:
        codS = validarNum(1, 9999, "ingrese el código del silo: ")
        if buscarSilos(codS) != -1:
            nom = validarString(1, 15, "ingrese el nombre del silo: ")
            grabarSilo(codP, codS, nom, 0, os.path.getsize(afSilos))
    else:
        print("el codigo de producto ingresado no existe")


def validarNum(min, max, n):
    x = int(input(f"{n}"))
    while not x >= min and x <= max:
        int(input(f"{n}"))
    return(x)


def validarString(min, max, n):
    x = input(f"{n}")
    while not len(x) >= min and len(x) <= max:
        x = input(f"{n}")
    return(x)


def grabarProd(cod, nom, pos):
    rProductos.codProducto = cod
    rProductos.nomProducto = nom
    formatearProductos(rProductos)
    alProductos.seek(pos)
    pickle.dump(rProductos, alProductos)
    alProductos.flush()


def grabarRubro(cod, nom, pos):
    rRubros.codRubro = cod
    rRubros.nomRubro = nom
    formatearRubros(rRubros)
    alRubros.seek(pos)
    pickle.dump(rRubros, alRubros)
    alRubros.flush()


def grabarRubroxProd(cod1, cod2, val1, val2, pos):
    rRubrosxProductos.codRubro = cod1
    rRubrosxProductos.codProducto = cod2
    rRubrosxProductos.valMinimo = val1
    rRubrosxProductos.valMaximo = val2
    formatearRXP(rRubrosxProductos)
    alRubrosxProducto.seek(pos)
    pickle.dump(rRubrosxProductos, alRubrosxProducto)
    alRubrosxProducto.flush()


def grabarSilo(codP, cod, nom, stock, pos):
    rSilos.codProducto = codP
    rSilos.codSilo = cod
    rSilos.nomSilo = nom
    rSilos.stock = stock
    formatearSilo(rSilos)
    alSilos.seek(pos)
    pickle.dump(rSilos, alSilos)
    alSilos.flush()


def baja():
    os.system('cls')
    cod = validarNum(0, 9999, "Ingrese el codigo del producto a eliminar (0 para salir): ")
    while cod != 0:
        x = buscarProducto(cod)
        if x == -1:
            print("el código que ingresó no existe")
            cod = int(input(
                "ingrese el codigo del producto a eliminar (0 para salir): "))
        else:
            alProductos.seek(x)
            rProductos = pickle.load(alProductos)
            rProductos.disponibilidad = False
            alProductos.seek(x)
            pickle.dump(rProductos, alProductos)
            alProductos.flush()
            cod = int(input(
                "ingrese el codigo del producto a eliminar (0 para salir): "))


#Consulta
def consulta():
    os.system('cls')
    alProductos.seek(0)
    tam = os.path.getsize(afProductos)
    while alProductos.tell() < tam:
        rProductos = pickle.load(alProductos)
        print(rProductos.codProducto, rProductos.nomProducto,
              rProductos.disponibilidad)
   
def consultaDelRubroXProducto(codProducto):
    tamanio = os.path.getsize(afRubrosxProducto)
    encontrado = False
    alRubrosxProducto.seek(0)
    while alRubrosxProducto.tell() < tamanio and not encontrado:
        pos = alRubrosxProducto.tell()
        rRubrosxProductos = pickle.load(alRubrosxProducto)
        if int(rRubrosxProductos.codProducto) == int(codProducto):
            encontrado = True
    if encontrado:
        alRubrosxProducto.seek(pos)
        rRubrosxProductos = pickle.load(alRubrosxProducto)
        codRubro = rRubrosxProductos.codRubro
        pos2 = buscarRubros(codRubro)
        alRubros.seek(pos2)
        rRubros = pickle.load(alRubros)
        print(codProducto, rRubros.nomRubro, rRubrosxProductos.valMinimo, rRubrosxProductos.valMaximo)

        valor = input('Ingrese el valor: ')
        if valor >= rRubrosxProductos.valMinimo and valor <= rRubrosxProductos.valMaximo:
            return 1
        else:
            return -1
 


# Modificacion
def modificacion():
    os.system('cls')
    consulta()
    cod = input("ingrese el codigo del producto a modificar: ")
    pos = buscarProducto(cod)
    x = 0
    while pos != -1 and x != 1:
        a = input("Ingrese el nuevo codigo: ")
        b = input("ingrese el nuevo nombre del producto: ")
        grabarProd(a, b, pos)
        x = 1
    if pos == -1:
        print("El código que ingresó no existe: ")
    os.system('pause')
        
def modificacionDeEstado(pos, estado):
    alOperaciones.seek(pos)
    rOperaciones = pickle.load(alOperaciones)
    rOperaciones.estado = estado
    formatearCamiones(rOperaciones)
    pickle.dump(rOperaciones, alOperaciones)
    alOperaciones.flush

# BUSQUEDAS
def buscarProducto(codprod):
    tamanio = os.path.getsize(afProductos)
    encontrado = False
    alProductos.seek(0)
    while alProductos.tell() < tamanio and not encontrado:
        pos = alProductos.tell()
        rProductos = pickle.load(alProductos)
        if int(rProductos.codProducto) == int(codprod):
            encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)


def buscarRubros(codRubro):
    tamanio = os.path.getsize(afRubros)
    encontrado = False
    alRubros.seek(0)
    while alRubros.tell() < tamanio and not encontrado:
        pos = alRubros.tell()
        rRubros = pickle.load(alRubros)
        if int(rRubros.codRubro) == int(codRubro):
            encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)

def buscarRubrosxProducto(codRubro, codProducto):
    tamanio = os.path.getsize(afRubrosxProducto)
    encontrado = False
    alRubrosxProducto.seek(0)
    while alRubrosxProducto.tell() < tamanio and not encontrado:
        pos = alRubrosxProducto.tell()
        rRubrosxProductos = pickle.load(alRubrosxProducto)
        if int(rRubrosxProductos.codRubro) == int(codRubro) and int(rRubrosxProductos.codProducto) == int(codProducto):
            encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)


def buscarSilos(codSilo):
    tamanio = os.path.getsize(afSilos)
    encontrado = False
    alSilos.seek(0)
    while alSilos.tell() < tamanio and not encontrado:
        pos = alSilos.tell()
        rSilos = pickle.load(alSilos)
        if int(rSilos.codSilo) == int(codSilo):
            encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)


def busquedaPatxFecha(patente, fecha):
    tamanio = os.path.getsize(afOperaciones)
    encontrado = False
    alOperaciones.seek(0)
    while alOperaciones.tell() < tamanio and not encontrado:
        pos = alOperaciones.tell()
        rOperaciones = pickle.load(alOperaciones)
        if rOperaciones.patente.strip() == patente.strip() and rOperaciones.fecha == fecha:
            if rOperaciones.estado == "A":
                return -2
            elif rOperaciones.estado != "P":
                encontrado = True
            else:
                return -3
    if encontrado:
        return(pos)
    else:
        return(-1)

def busquedaDeEstado(patente):
    tamaño = os.path.getsize(afOperaciones)
    encontrado = False
    alOperaciones.seek(0)
    while alOperaciones.tell() < tamaño and not encontrado:
        pos = alOperaciones.tell()
        rOperaciones = pickle.load(alOperaciones)
        if rOperaciones.patente.strip() == patente.strip() and rOperaciones.estado.strip() == 'A':
            encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)

def buscarProductoXPatente(patente):
    tamaño = os.path.getsize(afOperaciones)
    encontrado = False
    alOperaciones.seek(0)
    while alOperaciones.tell() < tamaño and not encontrado:
        pos = alOperaciones.tell()
        rOperaciones = pickle.load(alOperaciones)
        if rOperaciones.patente.strip() == patente.strip():
            encontrado = True
            codPro = rOperaciones.codProducto
    if encontrado:
        return(codPro)
    else:
        return(-1)


#Validaciones
def validarFecha():
    ok = False
    while not ok:
        f = input("ingrese la fecha del cupo en formato: DD-MM-AAAA: ")
        try:
            datetime.datetime.strptime(f, "%d-%m-%Y")
            ok = True
            print(f)
        except(ValueError):
            print("ingrese una fecha valida: ")
            ok = False
    return(f)


def validacionDePatente():
    patente = input('ingrese su patente por favor: ')
    while len(patente) != 6 and len(patente) != 7:
        patente = input('La patente no es valida, ingrese nuevamente su patente: ')
    return(patente)




# ENTREGA DE CUPOS
def cargaDeCupos(p, f, cod):
    rOperaciones.patente = p
    rOperaciones.fecha = f
    rOperaciones.codProducto = cod
    rOperaciones.estado = "P"
    formatearCamiones(rOperaciones)
    alOperaciones.seek(os.path.getsize(afOperaciones))
    pickle.dump(rOperaciones, alOperaciones)
    alOperaciones.flush()


def consultaCupos():
    alOperaciones.seek(0)
    tam = os.path.getsize(afOperaciones)
    while alOperaciones.tell() < tam:
        rOperaciones = pickle.load(alOperaciones)
        print(rOperaciones.patente, rOperaciones.fecha,
              rOperaciones.codProducto, rOperaciones.estado)


def entregaDeCupos():
    os.system('cls')
    opc = 1
    while opc != 2:
        pat = validacionDePatente()
        fecha = validarFecha()
        pos = busquedaPatxFecha(pat, fecha)
        if pos == -2:
            print('El camión ya arribó')
        elif pos == -3:
            print("la patente que ingresó ya está pendiente")
        elif pos == -1:
            codP = validarNum(0, 9999, "ingrese el codigo de producto: ")

            if buscarProducto(codP) != -1:
                cargaDeCupos(pat, fecha, codP)
                consultaCupos()
                opc = int(
                    input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))
                while opc != 1 and opc != 2:
                    opc = int(
                        input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))
            else:
                print("el codigo que ingresó no existe")
                opc = 2
        else:
            print("La patente que ingresó ya tiene cupo en esa fecha")

def busquedaPatxFechaRecepcion(pat, f):
    tamanio = os.path.getsize(afOperaciones)
    encontrado = False
    alOperaciones.seek(0)
    while alOperaciones.tell() < tamanio and not encontrado:
        pos = alOperaciones.tell()
        rOperaciones = pickle.load(alOperaciones)
        if rOperaciones.patente.strip() == pat.strip() and rOperaciones.fecha.strip() == f:
            if rOperaciones.estado.strip() == "A":
                return -2
            elif rOperaciones.estado.strip() == "P":
                encontrado = True
    if encontrado:
        return(pos)
    else:
        return(-1)

def cargaRecepcion(p, f, pos):
    rOperaciones.patente = p
    rOperaciones.fecha = f
    rOperaciones.estado = "A"
    formatearCamiones(rOperaciones)
    alOperaciones.seek(pos)
    pickle.dump(rOperaciones, alOperaciones)
    alOperaciones.flush()


# Recepcion
def menuRecepcion():
    os.system('cls')
    opc = 1
    while opc != 2:
        pat = validacionDePatente()
        fecha = validarFecha()
        pos = busquedaPatxFechaRecepcion(pat, fecha)
        if pos == -2:
            opc = int(input('El camión ya arribó, desea seguir ingresado?\n1: Si\n2: No\n'))

        elif pos != -1:
            cargaRecepcion(pat, fecha, pos)
            consultaCupos()
            opc = int(input('Desea seguir ingresando patentes?\n1: Si\n2: No\n'))
            while opc != 1 and opc != 2:
                opc = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))

        else:
            opc = int(input('La patente no existe, desea seguir ingresado?\n1: Si\n2: No\n'))
            while opc != 1 and opc != 2:
                opc = int(input('Opcion invalida, vuelva a intentarlo:\n1: Si\n2: No\n'))
        
    else:
        print("La patente que ingresó no tiene cupo en esa fecha")
        opc = 2

def registroDeCalidad():
    os.system('cls')
    patente = validacionDePatente()
    pos = busquedaDeEstado(patente)
    if pos != -1:
        codProducto = buscarProductoXPatente(patente)
        if consultaDelRubroXProducto(codProducto) == 1:
            modificacionDeEstado(pos, 'C')
            print('Producto con calidad')
        else:
            modificacionDeEstado(pos, 'R')
            print('Producto rechazado')
    os.system('pause')



def registroDePesoBruto():
    pass

def registroDeTara():
    pass

def menuReportes():
    consulta()


# Opciones del Menu principal
os.system('cls')
print('Bienvenido al menu principal: \n--- \n1: Administraciones \n2: Entrega de cupos \n3: Recepción \n4: Registro de calidad \n5: Registrar peso bruto \n6: Registrar descarga \n7: Registrar tara \n8: Reportes \n0: Salir')

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
            registroDeCalidad()
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


alOperaciones.close()
alProductos.close()
alRubros.close()
alRubrosxProducto.close()
alSilos.close()


