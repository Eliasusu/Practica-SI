import os
import pickle
import os.path
import datetime

class Ave:
    def __init__(self):  
        self.nro = 0 #5
        self.desc= "" #10

class Socio:
    def __init__(self):  
        self.nro = 0 #5
        self.nom = "" #10
        self.cant = 0 #3

class Avistaje:
    def __init__(self):  
        self.nroAve = 0   #5
        self.nroSocio = 0 #5
        self.fecha = ""  #12
        self.lugar = ""  #30

def mostrarMenu():
    print("")
    print("FINAL AVES")
    print("----------------\n")
    print("a - Registro de avistaje")
    print("b - Listado de historia migratoria")
    print("c - Listado cantidad de observaciones")
    print("d - Salir \n\n")

### validar Char
def validarChar(min, max):
    letra = input("Ingrese opcion ['a'-'d']: ").lower()
    while letra >max or letra <min:
        letra = input("Ingrese opcion ['a'-'d']: ").lower()
    return letra

##-- opc A
##validarFecha
def validarFecha():
    flag = True
    while flag:
        try:
            fecha = input("Ingresa una fecha en el formato DD/MM/AAAA: ")
            datetime.datetime.strptime(fecha, '%d/%m/%Y')
            print("Fecha valida")
            flag = False
        except ValueError:
            print("Fecha invalida")
    return fecha

#busqueda Secuencial por archivo Ave
def buscaAve(nA):
    global afAves, alAves, rAve
    tamanio = os.path.getsize(afAves)
    rAve = Ave()
    encontrado = False
    alAves.seek(0) 
    while alAves.tell()<tamanio and not encontrado:
        pos = alAves.tell()
        rAve = pickle.load(alAves)
        if int(rAve.nro) == nA:
            encontrado = True
    if encontrado:
        return pos
    else:
        return -1

#busqueda Secuencial por archivo Socio
def buscaSocio(nS):
    global afSocios, alSocios, rSocio
    tamanio = os.path.getsize(afSocios)
    rSocio = Socio()
    encontrado = False
    alSocios.seek(0) 
    while alSocios.tell()<tamanio and not encontrado:
        pos = alSocios.tell()
        rSocio = pickle.load(alSocios)
        if int(rSocio.nro) == nS:
            encontrado = True
    if encontrado:
        return pos
    else:
        return -1

##grabar(str(nroAve).ljust(5),str(nroSocio).ljust(5),fecha,lugar)
def grabar (nroA, nroS, fecha, lugar):
    global alAvistajes
    rAvistaje.nroAve = str(nroA).ljust(5)   #5
    rAvistaje.nroSocio = str(nroS).ljust(5) #5
    rAvistaje.fecha = fecha  #12
    rAvistaje.lugar = lugar  #30
    alAvistajes.seek(os.path.getsize(afAvistajes))
    pickle.dump(rAvistaje, alAvistajes)
    alAvistajes.flush()

##aumentarUno(nroSocio)
def aumentarUno(nS):
    pos = buscaSocio(nS)
    alSocios.seek(pos)
    rSocio = pickle.load(alSocios)
    rSocio.cant = str(int(rSocio.cant) + 1).ljust(3)
    alSocios.seek(pos) ##tengo que volver a pararme adelante del registro a actualizar
    pickle.dump(rSocio, alSocios)
    alSocios.flush()

def registrarAvistaje():
    #valida Ave
    nroAve = int(input('Ingrese nro de Ave: '))
    while buscaAve(nroAve) == -1:
        nroAve = int(input('Ingrese nro de Ave: '))
    #valida Socio
    nroSocio = int(input('Ingrese nro de Socio: '))
    while buscaSocio(nroSocio) == -1:
        nroSocio = int(input('Ingrese nro de Socio: '))
    fecha = validarFecha().ljust(12)
    lugar = input("Ingrese lugar: ").lower().ljust(30)
    grabar(nroAve,nroSocio,fecha,lugar)
    aumentarUno(nroSocio)
    print('Registro grabado exitosamente \n')

##-- opc B
def historiaMigratoria():
    global alAves, afAvistajes, alAvistajes, rAve
    #valida Ave
    nroAve = int(input('Ingrese nro de Ave: '))
    while buscaAve(nroAve) == -1:
        nroAve = int(input('Ingrese nro de Ave: '))
    print(rAve.desc,'\nHistoria migratoria: ')
    alAvistajes.seek(0)
    tamanio = os.path.getsize(afAvistajes)
    while alAvistajes.tell() < tamanio:
        rAvistaje = pickle.load(alAvistajes)
        if int(rAvistaje.nroAve) == int(nroAve):
            print(rAvistaje.lugar, rAvistaje.fecha)

##-- opc C
def ordenarSocios():
    global afSocios, alSocios
    alSocios.seek (0)
    aux = pickle.load(alSocios) #para con el tell saber cuanto pesa un registro
    tamReg = alSocios.tell() 
    tamArch = os.path.getsize(afSocios)
    cantReg = int(tamArch / tamReg)  
    for i in range(0, cantReg-1):
        for j in range (i+1, cantReg):
            alSocios.seek (i*tamReg, 0)
            auxi = pickle.load(alSocios)
            alSocios.seek (j*tamReg, 0)
            auxj = pickle.load(alSocios)
            if (auxi.cant < auxj.cant):
                alSocios.seek (i*tamReg, 0)
                pickle.dump(auxj, alSocios)
                alSocios.seek (j*tamReg, 0)
                pickle.dump(auxi,alSocios)
                alSocios.flush()

def observaciones():
    global afSocios, alSocios, rSocio
    ordenarSocios()
    alSocios.seek(0)
    tamanio = os.path.getsize(afSocios)
    while alSocios.tell() < tamanio:
        rSocio = pickle.load(alSocios)
        print(rSocio.nro, rSocio.nom, rSocio.cant)


### programa principal ###
afAves = "\\Users\\maiasutkowski\\Desktop\\aves.dat" 
afAvistajes = "\\Users\\maiasutkowski\\Desktop\\avistajes.dat" 
afSocios = "\\Users\\maiasutkowski\\Desktop\\socios.dat" 
##archivo Aves
if not os.path.exists(afAves):   
    alAves = open(afAves, "w+b")   
else:
    alAves = open(afAves, "r+b")
##archivo Socios
if not os.path.exists(afSocios):   
    alSocios = open(afSocios, "w+b")   
else:
    alSocios = open(afSocios, "r+b")
##archivo Avistajes
if not os.path.exists(afAvistajes):   
    alAvistajes = open(afAvistajes, "w+b")   
else:
    alAvistajes = open(afAvistajes, "r+b")
##variables auxiliares
rAve = Ave()
rSocio = Socio()
rAvistaje = Avistaje()
##menu
opc = 'a'
while opc != 'd':
    mostrarMenu()
    opc = validarChar('a','d')
    if opc == 'a':
        registrarAvistaje()
    elif opc == 'b':
        pass
        historiaMigratoria()
    elif opc == 'c':
        pass
        observaciones()
    elif opc == 'd':
        print("\n\nGracias por visitarnos ...\n\n")
        ##cierre de archivos
        alAves.close()
        alAvistajes.close()
        alSocios.close()

