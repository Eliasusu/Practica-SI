import sys
import os
import pickle
import os.path
import datetime

class Operacion:
    def __init__(self):  
        self.patente= "" #7
        self.codprod = 0 #5
        self.fechacupo = ""  #12
        self.estado = "" #1
        self.bruto = 0 #5
        self.tara = 0 #5

class Producto:
    def __init__(self):  
        self.codprod = 0 #5
        self.nomprod = "" #30


class Rubro:
    def __init__(self):  
        self.codrub = 0 #5
        self.nomrub = "" #30

class RubroxProd:
    def __init__(self):  
        self.codrub = 0 #5
        self.codprod = 0 #5
        self.valmin = 0.00 #3
        self.valmax = 0.00 #3


class Silo:
    def __init__(self):  
        self.codsilo = 0 #5
        self.nomsil = "" #30
        self.codprod = 0 #5
        self.stock = 0 #5

class Acum:
	def __init__(self):  
		self.pat = "" #7
		self.codprodu = 0 #5
		self.pbruto = 0 #5
		self.pneto = 0 #5
		self.cupo = "N" #1
		self.recib = "N" #1
        


def busquedaDicoRubro(codRubro):

    global afRub, alRub

    #Declarativas
    aux = Rubro()
    alRub.seek (0, 0)
    aux = pickle.load(alRub)
    tamReg = alRub.tell() 
    cantReg = os.path.getsize(afRub) // tamReg
    desde = 0
    hasta = cantReg-1
    encontrado = False 


    while not encontrado and desde <= hasta:
        medio = (desde + hasta) // 2 
        alRub.seek(medio*tamReg, 0)
        rRub = pickle.load(alRub)
        if int(rRub.codrub) == int(codRubro):
            encontrado = True
        else:
            if int(codRubro) < int(rRub.codrub):
                hasta = medio - 1
            else:
                desde = medio + 1
    
    if int(rRub.codrub) == int(codRubro):                    
        return medio*tamReg                         
    else:
        return -1   

def validarIngresoEntero(x,y,z):
	try:
		valor = int(x)
		if valor >= y and valor <= z:
			return True
		else:
			print(f"Por favor, ingrese un valor entre {y} y {z}")
			return False
	except ValueError:
		print(f"Por favor, ingrese un valor entero")
		return False


def buscaSiloProd(codProdx):
    global afSilos, alSilos, rSilo
    tamanio = os.path.getsize(afSilos)
    rSilo = Silo()
    encontrado = False
    alSilos.seek(0) 
	
    while alSilos.tell() < tamanio and not encontrado:
        pos = alSilos.tell()
        rSilo = pickle.load(alSilos)
        if int(rSilo.codprod) == int(codProdx):
            encontrado = True
    if encontrado:
        return pos
    else:
        return -1

def buscaSilo(codSilo):
    global afSilos, alSilos, rSilo
    tamanio = os.path.getsize(afSilos)
    rSilo = Silo()
    encontrado = False
    alSilos.seek(0) 
	
    while alSilos.tell() < tamanio and not encontrado:
        pos = alSilos.tell()
        rSilo = pickle.load(alSilos)
        if int(rSilo.codsilo) == codSilo:
            encontrado = True
    if encontrado:
        return pos
    else:
        return -1	



def nomProd(codPro):
	global afProd, alProd, rProd
	tamanio = os.path.getsize(afProd)
	rProd = Producto()
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	alProd.seek(0) 
	nomprod = ""

	while alProd.tell() < tamanio:
		pos = alProd.tell()
		rProd = pickle.load(alProd)
		if int(rProd.codprod) == codPro and rProd.nomprod != vacioNom:
			nomprod = rProd.nomprod

			return nomprod

def buscaProd(codPro):
    global afProd, alProd, rProd
    tamanio = os.path.getsize(afProd)
    rProd = Producto()
    encontrado = False
    vacioNom = ""
    vacioNom = vacioNom.ljust(30)
    alProd.seek(0) 
	

    while alProd.tell() < tamanio and not encontrado:
        pos = alProd.tell()
        rProd = pickle.load(alProd)
        if int(rProd.codprod) == codPro and rProd.nomprod != vacioNom:
            encontrado = True
    if encontrado:
        return pos
    else:
        return -1

def buscaRub(codRubro):
	global afRub, alRub, rRubro
	tamanio = os.path.getsize(afRub)
	rRubro = Rubro()
	alRub.seek(0) 
	encontrado = False
	#print(codRubro)
	while alRub.tell() < tamanio and not encontrado:
		pos = alRub.tell()
		rRubro = pickle.load(alRub)
		if int(rRubro.codrub) == int(codRubro):
			encontrado = True
	if encontrado:
		return pos
	else:
	    return -1

def buscaProdxRub(codRubro,codProdx):
	global afRubxProd, alRubxProd, rRubroxProd
	tamanio = os.path.getsize(afRubxProd)
	rRubroxProd = RubroxProd()
	alRubxProd.seek(0, 0)
	encontrado = False
	while alRubxProd.tell() < tamanio and not encontrado:
		pos = alRubxProd.tell()
		rRubroxProd = pickle.load(alRubxProd)
		if int(rRubroxProd.codrub) == codRubro and int(rRubroxProd.codprod) == codProdx:
			encontrado = True
	if encontrado:
		return pos
	else:
		return -1

def buscaPatFecha(patente, fecha):
	global afOpe, alOpe, rOpe
	tamanio = os.path.getsize(afOpe)
	rOpe = Operacion()
	alOpe.seek(0, 0)
	encontrado = False
	while alOpe.tell() < tamanio and not encontrado:
		pos = alOpe.tell()
		rOpe = pickle.load(alOpe)
		fechaParse = datetime.date.today().strftime("%d/%m/%Y")
		if rOpe.patente.strip() == patente.strip() and rOpe.fechacupo.strip() == fechaParse.strip():
			encontrado = True

	if encontrado:
		return pos
	else:
		return -1



def grabarSilo(codSilo,nomSil,CodProSilo,Stock):
	global afSilos, alSilos, rSilo
	rSilo = Silo()
	rSilo.codsilo = str(codSilo).ljust(5) #5
	rSilo.nomsil = str(nomSil).ljust(30) #30
	rSilo.codprod = str(CodProSilo).ljust(5) #5
	rSilo.stock = str(Stock).ljust(5) #5
	alSilos.seek(os.path.getsize(afSilos))
	pickle.dump(rSilo, alSilos)
	alSilos.flush()

def grabarRubxProd(codRubro,codProdx,valMin,valMax):
	global afRubxProd, alRubxProd, rRubroxProd 
	rRubroxProd = RubroxProd()
	rRubroxProd.codrub = str(codRubro).ljust(5) #5
	rRubroxProd.codprod = str(codProdx).ljust(5) #5
	rRubroxProd.valmin = str(valMin).ljust(3) #5
	rRubroxProd.valmax = str(valMax).ljust(3) #5
	alRubxProd.seek(os.path.getsize(afRubxProd))
	pickle.dump(rRubroxProd, alRubxProd)
	alRubxProd.flush()

def grabarRubro (codRubro,nomRubro):
	global afRub, alRub, rRubro
	rRubro = Rubro()
	rRubro.codrub = str(codRubro).ljust(5) #5
	rRubro.nomrub = nomRubro.upper() #30
	alRub.seek(os.path.getsize(afRub))
	pickle.dump(rRubro, alRub)
	alRub.flush()

def grabarAcum (patente,codProdx,cupo):
    global alAcum, afAcum, rAcum
    rAcum = Acum()
    rAcum.pat = patente.ljust(7) #5
    rAcum.codprodu = str(codProdx).ljust(5) #5
    rAcum.cupo = cupo #1
    alAcum.seek(os.path.getsize(afAcum))
    pickle.dump(rAcum, alAcum)
    alAcum.flush()

def grabarOperacion (patente,fecha,codProdx,estado):
    global alOpe, afOpe, rOpe
    rOpe = Operacion()
    rOpe.patente = str(patente).ljust(7) #5
    rOpe.fechacupo = str(fecha).ljust(12) #12
    rOpe.codprod = str(codProdx).ljust(5) #5
    rOpe.estado = estado.upper() #1
    alOpe.seek(os.path.getsize(afOpe))
    pickle.dump(rOpe, alOpe)
    alOpe.flush()


def grabarProd (codPro,nomProd):
	global alProd, afProd, rProd
	rProd = Producto()
	rProd.codprod = str(codPro).ljust(5) #5
	rProd.nomprod = nomProd.upper() #30
	alProd.seek(os.path.getsize(afProd))
	pickle.dump(rProd, alProd)
	alProd.flush()

def modificaProd (nomProd,pos):
    global alProd, afProd, rProd
    alProd.seek(pos, 0)
    rProd.nomprod = str(nomProd).ljust(30).upper() #5
    pickle.dump(rProd, alProd)
    alProd.flush()
    print("Se modifico el producto correctamente")
    print("Los datos actualizados del producto son:")
    print(str(rProd.codprod), rProd.nomprod)

def eliminaProd (nomProd,pos):
    global alProd, afProd, rProd
    alProd.seek(pos, 0)
    rProd.nomprod = str(nomProd).ljust(30) #5
    pickle.dump(rProd, alProd)
    alProd.flush()
    print("Se elimino el producto correctamente")
    listaProds()


def listaOpes():
	
	print()
	t = os.path.getsize(afOpe)
	if t==0:
		print ("No hay Operaciones registradas")
	else:
		encabezado = ''
		encabezado = encabezado + '{:<15}'.format("Patente")
		encabezado = encabezado + '{:<30}'.format("Código de Producto")
		encabezado = encabezado + '{:<20}'.format("Fecha Cupo")
		encabezado = encabezado + '{:<20}'.format("Estado")
		encabezado = encabezado + '{:<20}'.format("Bruto")
		encabezado = encabezado + '{:<20}'.format("Tara")
		print(encabezado)
		print("--------------------------------------------------------------------------------------------------------------------")
		alOpe.seek(0, 0)
		while alOpe.tell()<t:
			ope = pickle.load(alOpe)
			salida = ''
			salida = salida + '{:<15}'.format(str(ope.patente))
			salida = salida + '{:<30}'.format(ope.codprod)
			salida = salida + '{:<20}'.format(ope.fechacupo)
			salida = salida + '{:<20}'.format(ope.estado)
			salida = salida + '{:<20}'.format(ope.bruto)
			salida = salida + '{:<20}'.format(ope.tara)
			print(salida)
	print()

def listaSilos():
	
	print()
	t = os.path.getsize(afSilos)
	if t==0:
		print ("No hay Silos registrados")
	else:
		encabezado = ''
		encabezado = encabezado + '{:<15}'.format("Código de Silo")
		encabezado = encabezado + '{:<30}'.format("Nombre de Silo")
		encabezado = encabezado + '{:<20}'.format("Código de Producto")
		encabezado = encabezado + '{:<20}'.format("Stock")
		print(encabezado)
		print("---------------------------------------------------------------------------------")
		silo = Silo()
		alSilos.seek(0, 0)
		while alSilos.tell()<t:
			silo = pickle.load(alSilos)
			salida = ''
			salida = salida + '{:<15}'.format(str(silo.codsilo))
			salida = salida + '{:<30}'.format(str(silo.nomsil))
			salida = salida + '{:<20}'.format(str(silo.codprod))
			salida = salida + '{:<20}'.format(str(silo.stock))
			print(salida)
	print()

def listaProds():
	
	print()
	t = os.path.getsize(afProd)
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	if t==0:
		print ("No hay Productos registrados")
	else:
		encabezado = ''
		encabezado = encabezado + '{:<20}'.format("Código de Producto")
		encabezado = encabezado + '{:<30}'.format("Nombre de Producto")
		print(encabezado)
		print("---------------------------------------------------------------------------------")
		prod = Producto()
		alProd.seek(0, 0)
		while alProd.tell()<t:
			prod = pickle.load(alProd)
			if prod.nomprod != vacioNom:
				salida = ''
				salida = salida + '{:<20}'.format(str(prod.codprod))
				salida = salida + '{:<30}'.format(prod.nomprod)
				print(salida)
	print()

def mayorStock():
	global afSilos, alSilos, rSilo
	tamanio = os.path.getsize(afSilos)
	rSilo = Silo()
	alSilos.seek(0) 
	mayorStr = ''
	mayorStock = 0
	while alSilos.tell() < tamanio:
		rSilo = pickle.load(alSilos)
		if int(mayorStock) < int(rSilo.stock):
			mayorStock = rSilo.stock
			mayorStr = 'Código de Silo: ' +  str(rSilo.codsilo) + 'Nombre: ' + rSilo.nomsil.strip() + '   Stock: ' + str(mayorStock)

	return mayorStr

def listaRubros():
	
	print()
	t = os.path.getsize(afRub)
	if t==0:
		print ("No hay Rubros registrados")
	else:
		encabezado = ''
		encabezado = encabezado + '{:<20}'.format("Código de Rubro")
		encabezado = encabezado + '{:<30}'.format("Nombre de Rubro")
		print(encabezado)
		print("---------------------------------------------------------------------------------")
		rub = Rubro()
		alRub.seek(0, 0)
		while alRub.tell()<t:
			rub = pickle.load(alRub)
			salida = ''
			salida = salida + '{:<20}'.format(str(rub.codrub))
			salida = salida + '{:<30}'.format(rub.nomrub)
			print(salida)
	print()
def listaRubrosxProd():
	
	print()
	t = os.path.getsize(afRubxProd)
	if t==0:
		print ("No hay Rubros x Productos")
	else:
		encabezado = ''
		encabezado = encabezado + '{:<20}'.format("Código de Rubro")
		encabezado = encabezado + '{:<20}'.format("Código de Producto")
		encabezado = encabezado + '{:<15}'.format("Valor Mínimo")
		encabezado = encabezado + '{:<15}'.format("Valor Máximo")
		print(encabezado)
		print("---------------------------------------------------------------------------------")
		rubxprod = RubroxProd()
		alRubxProd.seek(0, 0)
		while alRubxProd.tell()<t:
			rubxprod = pickle.load(alRubxProd)
			salida = ''
			salida = salida + '{:<20}'.format(str(rubxprod.codrub))
			salida = salida + '{:<20}'.format(rubxprod.codprod)
			salida = salida + '{:<15}'.format(rubxprod.valmin)
			salida = salida + '{:<15}'.format(rubxprod.valmax)
			print(salida)
	print()


def listaAcum():
		
	print()
	tamAcum = os.path.getsize(afAcum)
	if tamAcum == 0:
		print ("No hay Acumuladores")
	else:

		encabezado = ''
		encabezado = encabezado + '{:<20}'.format("Patente")
		encabezado = encabezado + '{:<20}'.format("Código de Producto")
		encabezado = encabezado + '{:<15}'.format("Peso Neto")
		encabezado = encabezado + '{:<15}'.format("Peso Bruto")
		encabezado = encabezado + '{:<5}'.format("Cupo")
		encabezado = encabezado + '{:<5}'.format("Recibido")
		print(encabezado)
		print("-----------------------------------------------------------------------------------------")
		rAcum = Acum()
		alAcum.seek(0, 0)
		while alAcum.tell()<tamAcum:

			rAcum = pickle.load(alAcum)
			salida = ''
			salida = salida + '{:<20}'.format(str(rAcum.pat))
			salida = salida + '{:<20}'.format(str(rAcum.codprodu))
			salida = salida + '{:<15}'.format(str(rAcum.pneto))
			salida = salida + '{:<15}'.format(str(rAcum.pbruto))
			salida = salida + '{:<5}'.format(str(rAcum.cupo))
			salida = salida + '{:<5}'.format(str(rAcum.recib))
			print(salida)
	

def ABMProducto(op):

	if op == "A":
		print("Alta de Producto")

		codProdt = int(input("Ingrese código  de Producto, entre 1 y 99999 [0 para Volver]: "))

		while not validarIngresoEntero(codProdt, 0, 99999):
			codProdt = input("Ingresar código de Producto nuevamente: ")

		codProdt = int(codProdt)
		while codProdt != 0:
			pos = buscaProd(codProdt)
			if pos == -1:
				nomProd = input("Nombre del Producto <hasta 30 caracteres>: ")
				while len(nomProd)<1 or len(nomProd)>30:
					nomProd = input("Incorrecto - Nombre del Producto  <hasta 30 caracteres>: ")

				nomProd = nomProd.ljust(30)
				grabarProd(codProdt,nomProd)
				print('Alta de Producto Exitosa \n')
				listaProds()
			else:
				print("Codigo de Producto ya existente")
			codProdt = int(input("Ingrese código  de Producto, entre 1 y 99999 [0 para Volver]: "))
			while not validarIngresoEntero(codProdt, 0, 99999):
				codProdt = int(input("Ingresar código de Producto nuevamente: "))


	elif op == 'B':
		print("Baja de Producto")
		listaProds()
		codProdt = int(input("Ingrese código de Producto a Eliminar [0 para Volver]: "))
		
		while not validarIngresoEntero(codProdt, 0, 99999):
			codProdt = int(input("Incorrecto - Ingresar código de Producto nuevamente: "))
		

		while codProdt != 0:
			pos = buscaProd(codProdt)
			if pos != -1:

				alProd.seek(pos, 0)	
				rProd = pickle.load(alProd)	
				nomProd = ""
				rProd.nomprod = nomProd.ljust(30)
				eliminaProd(nomProd,pos)
			else:
				print()
				print("El codigo de producto no corresponde a un código existente")
				print()

			listaProds()
			codProdt = int(input("Ingrese código de Producto a Eliminar [0 para Volver]: "))
			while not validarIngresoEntero(codProdt, 0, 99999):
				codProdt = int(input("Incorrecto - Ingresar código de Producto nuevamente: "))

	elif op == 'C':
		listaProds()

	else:
		print("Modificacion de Producto")
		listaProds()
		codProdt = int(input("Ingrese código de Producto a Modificar [0 para Volver]: "))
		
		while not validarIngresoEntero(codProdt, 0, 99999):
			codProdt = input("Incorrecto - Ingresar código de Producto nuevamente: ")

		codProdt = int(codProdt)
		while codProdt != 0:
			pos = buscaProd(codProdt)
			if pos != -1:
				alProd.seek(pos, 0)	
				rProd = pickle.load(alProd)
				print("Producto a actualizar el nombre:")
				print(str(rProd.codprod), rProd.nomprod)
				nomProd = input("Nombre del Producto <hasta 30 caracteres>: ")
				while len(nomProd)<1 or len(nomProd)>30:
					nomProd = input("Incorrecto - Nombre del Producto  <hasta 40 caracteres>: ")

				modificaProd(nomProd,pos)
			else:
				print("El codigo de producto no corresponde a un código existente")
			codProdt = int(input("Ingrese código de Producto a Modificar [0 para Volver]: "))
		
			while not validarIngresoEntero(codProdt, 0, 99999):
				codProdt = int(input("Incorrecto - Ingresar código de Producto nuevamente: "))
				
def multiplesAltas(ops):
	if ops == 'C':
		listaRubros()
		print("Alta de RUBROS")

		codRubro = int(input("Ingrese código  de Rubro, entre 1 y 99999 [0 para Volver]: "))
		while not validarIngresoEntero(codRubro, 0, 99999):
			codRubro = int(input("Ingresar código de Rubro nuevamente: "))

		codRubro = int(codRubro)
		while codRubro != 0:
			pos = buscaRub(codRubro)
			if pos == -1:
				nomRubro = input("Nombre del Rubro <hasta 30 caracteres>: ")
				while len(nomRubro)<1 or len(nomRubro)>30:
					nomRubro = input("Incorrecto - Nombre del Rubro  <hasta 30 caracteres>: ")

				grabarRubro(codRubro,nomRubro)
				print('Alta de Rubro Exitosa \n')
				listaRubros()
			else:
				print("Codigo de Rubro ya existente")
			codRubro = int(input("Ingrese código  de Rubro, entre 1 y 99999 [0 para Volver]: "))
			while not validarIngresoEntero(codRubro, 0, 99999):
				codRubro = int(input("Ingresar código de Rubro nuevamente: "))


	elif ops == 'D':
		listaRubrosxProd()
		print("Alta de RUBROS X PRODUCTOS")
		validado = False
		codRubro = int(input("Ingrese código  de Rubro, entre 1 y 99999 [0 para Volver]: "))
		while not validarIngresoEntero(codRubro, 0, 99999):
			codRubro = int(input("Ingresar código de Rubro nuevamente: "))

		while codRubro != 0 and validado == False:
			pos = buscaRub(codRubro)
			if pos != -1:
				codProdx = int(input("Ingrese código de Producto a Agregar: "))
				while not validarIngresoEntero(codProdx, 0, 99999):
					codProdx = int(input("Incorrecto - Ingresar código de Producto nuevamente: "))

				validado = False
				while codProdx != 0 and validado == False:
					posp = buscaProd(codProdx)
					if posp != -1:
						posr = buscaProdxRub(codRubro,codProdx)	
						if posr != -1:
							print()
							print("Codigo de Rubro y Producto ya cargados")
							print()
							validado = True
						else:
							valMin = int(input("Ingrese el Valor Mínimo: "))
							while not validarIngresoEntero(valMin, 0, 100):
								valMin = int(input("Incorrecto - Ingrese el Valor Mínimo nuevamente. Mínimo: 0):"))

							valMax = int(input("Ingrese el Valor Máximo: "))
							while not validarIngresoEntero(valMax, 0, 100):
								valMax = int(input("Incorrecto - Ingrese el Valor Máximo nuevament. Máximo: 100) "))
							grabarRubxProd(codRubro,codProdx,valMin,valMax)
							print('Alta de Rubro x Producto Exitosa \n')
							listaRubrosxProd()
							validado = True
					else:
						print("Codigo de Producto inexistente")
						codProdx = int(input("Ingrese código de Producto a Agregar [0 para Volver]: "))
				
						while not validarIngresoEntero(codProdx, 0, 99999):
							codProdx = int(input("Incorrecto - Ingresar código de Producto nuevamente [0 para Volver]: "))
						

			else:
				print("Codigo de Rubro inexistente")
			codRubro = int(input("Ingrese código  de Rubro, entre 1 y 99999 [0 para Volver]: "))
			while not validarIngresoEntero(codRubro, 0, 99999):
				codRubro = int(input("Ingresar código de Rubro nuevamente: "))
			validado = False

	else:
		listaSilos()
		print("Alta de SILOS")
		codSilo = int(input("Ingrese código  de Silo, entre 1 y 99999 [0 para Volver]: "))
		while not validarIngresoEntero(codSilo, 0, 99999):
			codSilo = int(input("Ingresar código de Silo nuevamente: "))

		while codSilo != 0:
			pos = buscaSilo(codSilo)
			if pos == -1:
				nomSil= input("Nombre del Silo <hasta 30 caracteres>: ")
				while len(nomSil)<1 or len(nomSil)>30:
					nomSil = input("Incorrecto - Nombre del Silo  <hasta 30 caracteres>: ")

				listaProds()
				CodProSilo = int(input("Ingrese código de Producto del Silo: "))
				
				while not validarIngresoEntero(CodProSilo, 0, 99999) or buscaProd(CodProSilo) == -1:
					CodProSilo = int(input("Incorrecto - Ingresar código de Producto nuevamente: "))

				Stock = int(input("Ingrese Stock del Silo: "))
				while not validarIngresoEntero(CodProSilo, 0, 99999) :
					Stock = int(input("Incorrecto - Ingresar Stock del Silo nuevamente: "))
				
				grabarSilo(codSilo,nomSil,CodProSilo,Stock)
				print('Alta de Silo Exitosa \n')
				listaSilos()
			else:
				print("Codigo de Silo ya existente")

			codSilo = int(input("Ingrese código  de Silo, entre 1 y 99999 [0 para Volver]: "))
			while not validarIngresoEntero(codSilo, 0, 99999):
				codSilo = int(input("Ingresar código de Silo nuevamente: "))


def administ():
		print(opcionesms)
		opms = input('Elija su opción\n')
		opms = opms.upper()
		while opms != 'V':
			if (opms == 'A' or opms == 'F' or opms == 'G'):
				print(mc)
			if (opms == 'C' or opms == 'D' or opms == 'E'):
				print(opcionesmt)
				opmt = input('Elija su opción\n')
				opmt = opmt.upper()
				while opmt != 'V':
					if ( opmt == 'B' or opmt == 'C' or opmt == 'M'):
						print(mc)
					elif opmt == 'A':
						multiplesAltas(opms)
					else:
						if (opmt != 'V'):
							print('Opción Incorrecta. Vuelva a ingresar una opción correcta.\n')
					print(opcionesmt)
					opmt = input('Elija su opción\n')
					opmt = opmt.upper()
			elif opms == 'B':
					print(opcionesmt)
					opmt = input('Elija su opción\n')
					opmt = opmt.upper()
					while opmt != 'V':
						if (opmt == 'A' or opmt == 'B' or opmt == 'C' or opmt == 'M'):
							ABMProducto(opmt)
						else:
							if (opmt != 'V'):
								print('Opción Incorrecta. Vuelva a ingresar una opción correcta.\n')
						print(opcionesmt)
						opmt = input('Elija su opción\n')
						opmt = opmt.upper()
			else:
				if (opms != 'V'):
					print('Opción Incorrecta. Vuelva a ingresar una opción correcta:')

			print(opcionesms)
			opms = input('Elija su opción\n')
			opms = opms.upper()

def Rechazos():
	print()

	fecha = validarFecha().ljust(12)
	t = os.path.getsize(afOpe)
	if t==0:
		print ("No hay Operaciones registradas")
	else:
		print()
		print("----Listado Patentes de los Camiones Rechazados----")
		print()
		encabezado = ''
		encabezado = encabezado + '{:<15}'.format("Patente")
		print(encabezado)
		print("-------------------------------------------")
		rOpe = Operacion()
		alOpe.seek(0, 0)
		cant = 0
		while alOpe.tell()<t:
			rOpe = pickle.load(alOpe)
			est = "R"
			if rOpe.fechacupo.strip() == fecha.strip() and rOpe.estado.strip() == est :
				salida = ''
				salida = salida + '{:<15}'.format(str(rOpe.patente))
				print(salida)
				cant = cant + 1
		if cant == 0:
			print("No existen camiones rechazados")
	print()


##validarFecha
def validarFecha():
    flag = True
    while flag:
        try:
            fecha = input("Ingresa una fecha en el formato DD/MM/AAAA: ")
            datetime.datetime.strptime(fecha, '%d/%m/%Y')
            flag = False
        except ValueError:
            print("Fecha invalida")
    return fecha



def BuscaPatCupo(patente):
	global alOpe, afOpe, rOpe
	tamanio = os.path.getsize(afOpe)
	#rOpe = Operacion()
	alOpe.seek(0, 0)
	encontrado = False

	while alOpe.tell() < tamanio and not encontrado:
		pos = alOpe.tell()
		rOpe = pickle.load(alOpe)
		fechaParse = datetime.date.today().strftime("%d/%m/%Y")
		if rOpe.patente.strip() == patente.strip() and rOpe.fechacupo.strip() == fechaParse.strip():
			encontrado = True
	if encontrado:
		return pos
	else:
		return -1	
	
def BuscaPatAcum(patente):
	global alAcum, afAcum, rAcum
	tamanio = os.path.getsize(afAcum)
	rAcum = Acum()
	alAcum.seek(0, 0)
	encontrado = False
	while alAcum.tell() < tamanio and not encontrado:
		posb = alAcum.tell()
		rAcum = pickle.load(alAcum)
		if rAcum.pat.strip() == patente.strip():
			encontrado = True

	if encontrado:
		return posb
	else:
		return -1

def BuscaEstPat(patente):
	global alOpe, afOpe, rOpe
	tamanio = os.path.getsize(afOpe)
	rOpe = RubroxProd()
	alOpe.seek(0, 0)
	encontrado = False
	while alOpe.tell() < tamanio and not encontrado:
		pos = alOpe.tell()
		rOpe = pickle.load(alOpe)
		if rOpe.patente.strip() == patente.strip():
			encontrado = True
	if encontrado:
		return pos
	else:
		return -1

 

def validapatente(pat):
	val = False
	if pat != '0':
		if pat.isalnum() == False:
			print('La patente debe ser alfanumerica')
		elif len(pat) < 6 or len(pat) > 7:
			print('Patente debe contener un mínimo de 6 caracteres y un máximo de 7 caracteres')
		else:
			val = True
	else:
		val = True
	return val 


def cantcupos():
	print()
	t = os.path.getsize(afAcum)
	rAcum = Acum()
	cantcup = 0
	alAcum.seek(0, 0)
	while alAcum.tell() < t:
		rAcum = pickle.load(alAcum)
		if rAcum.cupo == 'S':
			cantcup = cantcup + 1
	
	return cantcup

def cantrecs():
	print()
	t = os.path.getsize(afAcum)
	rAcum = Acum()
	cantrec = 0
	alAcum.seek(0, 0)
	while alAcum.tell() < t:
		rAcum = pickle.load(alAcum)
		if rAcum.recib == 'S':
			cantrec = cantrec + 1
	
	return cantrec

def ordenarAcumxProd():
    global afAcum, alAcum
    alAcum.seek (0)
    aux = pickle.load(alAcum) 
    tamReg = alAcum.tell() 
    tamArch = os.path.getsize(afAcum)
    cantReg = int(tamArch / tamReg)  
    for i in range(0, cantReg-1):
        for j in range (i+1, cantReg):
            alAcum.seek (i*tamReg, 0)
            auxi = pickle.load(alAcum)
            alAcum.seek (j*tamReg, 0)
            auxj = pickle.load(alAcum)
            if (auxi.codprodu > auxj.codprodu):
                alAcum.seek (i*tamReg, 0)
                pickle.dump(auxj, alAcum)
                alAcum.seek (j*tamReg, 0)
                pickle.dump(auxi,alAcum)
                alAcum.flush()



def pNetoXProdTotal(codProd):
	ordenarAcumxProd()
	print()
	pNetoTotal = 0
	t = os.path.getsize(afAcum)
	rAcum = Acum()
	alAcum.seek(0, 0)
	while alAcum.tell() < t:
		rAcum = pickle.load(alAcum)
		if str(rAcum.codprodu).strip() == str(codProd).strip():
			if rAcum.pneto.strip() != '':
				pNetoTotal = pNetoTotal + int(rAcum.pneto)

	return pNetoTotal

def patMenorXProd(codProd):
	ordenarAcumxProd()
	print()
	pNetoTotal = 0
	t = os.path.getsize(afAcum)
	rAcum = Acum()
	alAcum.seek(0, 0)
	pBrutoMenor = 0
	patNetoMenor = ""
	while alAcum.tell() < t:
		rAcum = pickle.load(alAcum)
		if str(rAcum.codprodu).strip() == str(codProd).strip():
			if rAcum.pbruto.strip() != '':
				pBruto = int(rAcum.pbruto)
				if pBrutoMenor < pBruto:
					pBrutoMenor =  int(rAcum.pbruto)
					patNetoMenor = rAcum.pat


	return patNetoMenor

def cantCamXProd(codProd):
	ordenarAcumxProd()
	print()
	cantCam = 0
	t = os.path.getsize(afAcum)
	rAcum = Acum()
	alAcum.seek(0, 0)
	while alAcum.tell() < t:
		rAcum = pickle.load(alAcum)
		if str(rAcum.codprodu).strip() == str(codProd).strip() and rAcum.cupo == 'S' and rAcum.recib == 'S':
			cantCam = cantCam + 1

	return cantCam


def canttotalxprod():
	print('Cantidad total de camiones de cada producto: ')
	rAcum = Acum()
	alAcum.seek(0, 0)
	t = os.path.getsize(afProd)
	auxP = 0
	cantR = 0
	nomprod = ""
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	prod = Producto()
	alProd.seek(0, 0)
	cantcam = 0
	while alProd.tell()<t:
		prod = pickle.load(alProd)
		if prod.nomprod != vacioNom:
			codProd = int(prod.codprod)
			cantcam = cantCamXProd(codProd)
			nomprod = nomProd(codProd)
			if cantcam != 0:
				print('Producto: ', nomprod, ' Cantidad de Camiones : ',cantcam)			
	print()


def pnetoxprod():
	print('Peso neto total de cada producto: ')
	rAcum = Acum()
	alAcum.seek(0, 0)
	t = os.path.getsize(afProd)
	auxP = 0
	cantR = 0
	nomprod = ""
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	prod = Producto()
	alProd.seek(0, 0)
	pnetoTot = 0
	cantcam = 0
	while alProd.tell()<t:
		prod = pickle.load(alProd)
		if prod.nomprod != vacioNom:
			codProd = int(prod.codprod)
			pnetoTot = pNetoXProdTotal(codProd)
			nomprod = nomProd(codProd)
		if pnetoTot != 0:
			print('Producto: ', nomprod, ' Peso Neto Total: ',pnetoTot)


	print()

def promxprod():
	print('Promedio del peso neto de producto por camión de ese producto.: ')
	t = os.path.getsize(afProd)
	auxP = 0
	nomprod = ""
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	prod = Producto()
	alProd.seek(0, 0)
	pnetoTot = 0
	while alProd.tell()<t:
		prod = pickle.load(alProd)
		if prod.nomprod != vacioNom:
			codProd = int(prod.codprod)
			pnetoTot = pNetoXProdTotal(codProd)
			cantcam = cantCamXProd(codProd)
			nomprod = nomProd(codProd)
			if cantcam == 0:
				prom = 0
			else:
				prom = pnetoTot / cantcam
			if cantcam != 0:
				print('Producto: ', nomprod, ' Promedio del peso neto de producto: ',prom)	
	
	print()

def patmenor():
	print('Patente del camión de cada producto que menor cantidad de dicho producto descargó: ')
	
	t = os.path.getsize(afProd)
	auxP = 0
	nomprod = ""
	vacioNom = ""
	vacioNom = vacioNom.ljust(30)
	prod = Producto()
	alProd.seek(0, 0)
	pnetoTot = 0
	while alProd.tell()<t:
		prod = pickle.load(alProd)
		if prod.nomprod != vacioNom:
			codProd = int(prod.codprod)
			patNetoMenor = patMenorXProd(codProd)
			nomprod = nomProd(codProd)
			if patNetoMenor.strip() != '':
				print('Producto: ', nomprod, ' Patente del camión que menor producto descargó: ',patNetoMenor)	
	
	print()

def entcupos():

	print()
	listaOpes()
	print("Entrega de Cupos")
	patente = -1
	while patente != '0': 
			patente = input('Ingresar la patente del camión  [0: Volver]\n')
			patente = patente.upper()

			if patente != '0':
				while not validapatente(patente):
					patente = input('Ingresar la patente del camión  [0: Volver]\n')
					patente = patente.upper()
				if patente != '0':
					fecha = validarFecha().ljust(12)
					pos = buscaPatFecha(patente, fecha)
					if pos == -1:
						listaProds()
						codProdx = int(input("Ingrese código de Producto: "))
					
						while buscaProd(codProdx) == -1:
							codProdx = int(input("Codigo inexistente - Ingresar código de Producto nuevamente : "))

						cupo = 'S'
						estado = 'P'

						grabarOperacion(patente,fecha,codProdx,estado)

						grabarAcum(patente,codProdx,cupo)
						
						print("Se ha entregado el cupo correctamente")
						listaOpes()
					else:
						if patente != '0':
							print()
							print("Cupo ya otorgado")
							print()
					

					
	print()

def recepcion():
	
	print()
	listaOpes()
	print("Recepción")
	patente = -1
	while patente != '0': 
			patente = input('Ingresar la patente del camión  [0: Volver]\n')
			patente = patente.upper()

			if patente != '0':
				while not validapatente(patente):
					patente = input('Ingresar la patente del camión  [0: Volver]\n')
					patente = patente.upper()

				pos = BuscaPatCupo(patente)
				posb = BuscaPatAcum(patente)

				if pos != -1:
					alOpe.seek(pos,0)
					Ope = pickle.load(alOpe)
					estadopat = Ope.estado
				
				
				if pos != -1 and estadopat == 'P':
									
					alAcum.seek(posb, 0)
					rAcum.recib = "S".strip()
					rAcum.pat = rAcum.pat.ljust(7)
					rAcum.codprodu = rAcum.codprodu.ljust(5)
					rAcum.pbruto = str(rAcum.pbruto).ljust(5)
					rAcum.pneto = str(rAcum.pneto).ljust(5)
					rAcum.cupo = rAcum.cupo.ljust(1)
					
					pickle.dump(rAcum, alAcum)
					alAcum.flush()
					

					alOpe.seek(pos, 0)
					rOpe.estado = 'A'.ljust(1)
					pickle.dump(rOpe, alOpe)
					alOpe.flush()

					print("Se ha recepcionado el camión correctamente")
					listaOpes()
				elif pos != -1 and estadopat != 'P':
					print("El camion no se encuentra en estado 'Pendiente' ")	
				else:
					if patente != '0':
						print("No se ha encontrado la patente con cupo en la fecha de Hoy")			
	print()



def regcalidad():
	print()
	listaOpes()
	print("Registrar Calidad")
	patente = -1
	conterr = 0
	while patente != '0': 
			patente = input('Ingresar la patente del camión  [0: Volver]\n')
			patente = patente.upper()

			if patente != '0':
				while not validapatente(patente):
					patente = input('Ingresar la patente del camión  [0: Volver]\n')
					patente = patente.upper()
				posp = BuscaEstPat(patente)
				if posp != -1:
					alOpe.seek(posp,0)
					Ope = pickle.load(alOpe)
					estadopat = Ope.estado
					prodcam = str(Ope.codprod.strip())	

				
				if posp != -1 and estadopat == 'A':
					print()
					t = os.path.getsize(afRubxProd)
					print('Rubros del Producto del camión')
					encabezado = ''
					encabezado = encabezado + '{:<20}'.format("Código de Rubro")
					encabezado = encabezado + '{:<30}'.format("Nombre de Rubro")
					encabezado = encabezado + '{:<15}'.format("Valor Mínimo")
					encabezado = encabezado + '{:<15}'.format("Valor Máximo")

					print(encabezado)
					print("---------------------------------------------------------------------------------")
					rubxprod = RubroxProd()
					rub = Rubro()
					alRubxProd.seek(0, 0)
					alRub.seek(0, 0)
					while alRubxProd.tell()<t:
						rubxprod = pickle.load(alRubxProd)
						if rubxprod.codprod.strip() == prodcam.strip():

							codRubro = rubxprod.codrub
							pos = busquedaDicoRubro(codRubro)
							alRub.seek(pos,0)
							rRubro = pickle.load(alRub)
							salida = ''
							salida = salida + '{:<20}'.format(str(rubxprod.codrub))
							salida = salida + '{:<30}'.format(rRubro.nomrub)
							salida = salida + '{:<15}'.format(rubxprod.valmin)
							salida = salida + '{:<15}'.format(rubxprod.valmax)
							print(salida)	
							
							valcal = int(input('Ingrese el valor de calidad: '))
							while not validarIngresoEntero(valcal, 0, 100):
								valcal = int(input("Incorrecto - Ingrese el Valor de Calidad nuevamente [0-100]:   \n"))

							if (int(rubxprod.valmax) >= valcal and int(rubxprod.valmin) <= valcal):
								print()
								print("Supera la prueba de calidad")
								print()
							else:
								print()
								print("No Supera la prueba de calidad")
								print()
								conterr = conterr + 1
							
					if conterr >= 2:
						alOpe.seek(posp, 0)
						rOpe.estado = 'R'
						rOpe.estado = rOpe.estado.ljust(1)
						print()
						print("Camion no ha pasado pruebas de calidad suficientes. Rechazado")
						print()
					else:
						print()
						print("Camión aceptado 'Con Calidad'")
						print()
						alOpe.seek(posp, 0)
						rOpe.estado = 'C'
						rOpe.estado = rOpe.estado.ljust(1)


					pickle.dump(rOpe, alOpe)
					alOpe.flush()


					listaOpes()
					print()

				elif posp != -1 and estadopat != 'A': 
					print("Patente no se encuentra en estado 'Arribado'")
				else:
					if patente != '0' or patente == -1:
						print("Patente no registrada")	
	print()

def regpesbruto():
	print()
	listaOpes()
	print("Registrar Peso Bruto")
	patente = -1
	while patente != '0': 
			patente = input('Ingresar la patente del camión  [0: Volver]\n')
			patente = patente.upper()

			if patente != '0':
				while not validapatente(patente):
					patente = input('Ingresar la patente del camión  [0: Volver]\n')
					patente = patente.upper()
				pos = BuscaEstPat(patente)

				if pos != -1:
					alOpe.seek(pos,0)
					Ope = pickle.load(alOpe)
					estadopat = Ope.estado			

				if pos != -1 and estadopat == 'C':
					pesoBruto = int(input("Ingrese el Peso Bruto: "))
					while not validarIngresoEntero(pesoBruto, 0, 99999):
						valMax = int(input("Incorrecto - Ingrese el Peso Bruto nuevamente ) "))

					posb = BuscaPatAcum(patente)
					#Acumulador
					alAcum.seek(posb, 0)
					rAcum.pat = rAcum.pat.ljust(7)
					rAcum.codprodu = rAcum.codprodu.ljust(5)
					rAcum.pneto = str(rAcum.pneto).ljust(5)
					rAcum.cupo = rAcum.cupo.ljust(1)
					rAcum.recib = rAcum.recib.ljust(1)
					rAcum.pbruto = str(pesoBruto).ljust(5)
					pickle.dump(rAcum, alAcum)
					alAcum.flush()


					alOpe.seek(pos, 0)
					rOpe.estado = 'B'.ljust(1)
					rOpe.bruto = str(pesoBruto).ljust(5)
					pickle.dump(rOpe, alOpe)
					alOpe.flush()



					print()
					print("Se ha registrado el peso bruto correctamente")
					print()
					listaOpes()
				elif pos != -1 and estadopat != 'C': 
					print()
					print("Patente no se encuentra en estado 'En Calidad'")
					print()
				else:
					if patente != '0':
						print()
						print("Patente no registrada")
						print()	
	print()

def regtara():
	print()
	print("Registrar Tara")
	listaOpes()
	patente = -1
	while patente != '0': 
			patente = input('Ingresar la patente del camión  [0: Volver]\n')
			patente = patente.upper()

			if patente != '0':
				while not validapatente(patente):
					patente = input('Ingresar la patente del camión  [0: Volver]\n')
					patente = patente.upper()
				pos = BuscaEstPat(patente)

				if pos != -1:
					alOpe.seek(pos,0)
					Ope = pickle.load(alOpe)
					estadopat = Ope.estado	
					pesBruto = int(Ope.bruto)
					prodcam = int(Ope.codprod)		

				if pos != -1 and estadopat == 'B':
					tara = int(input("Ingrese la Tara del Camión: "))
					while not validarIngresoEntero(tara, 0, 99999):
						tara = int(input("Incorrecto - Ingrese la Tara nuevamente: "))

					while tara > pesBruto :
						tara = int(input("Incorrecto - Tara no puede ser mayor a Peso Bruto del Camión: "))

					posSilo = buscaSiloProd(prodcam)
					pesNeto = pesBruto - tara
					

					#Acumulador
					posb = BuscaPatAcum(patente)
					alAcum.seek(posb, 0)
					rAcum.pat = rAcum.pat.ljust(7)
					rAcum.codprodu = rAcum.codprodu.ljust(5)
					rAcum.pneto = str(pesNeto).ljust(5)
					rAcum.cupo = rAcum.cupo.ljust(1)
					rAcum.recib = rAcum.recib.ljust(1)
					rAcum.pbruto = rAcum.pbruto.ljust(5)					
					pickle.dump(rAcum, alAcum)
					alAcum.flush()


					##Actualizo Stock del Silo
					alSilos.seek(posSilo, 0)
					stAcum = int(rSilo.stock) + int(pesNeto)
					rSilo.stock = str(stAcum).ljust(5)
					pickle.dump(rSilo, alSilos)
					alSilos.flush()
					
					##Actualizo Operacion con la Tara y Estado
					alOpe.seek(pos, 0)
					rOpe.estado = 'F'.ljust(1)
					rOpe.tara = str(tara).ljust(5)
					pickle.dump(rOpe, alOpe)
					alOpe.flush()
					print()
					print("Se ha registrado la tara correctamente")
					print()
					listaOpes()
					listaSilos()
				elif pos != -1 and estadopat != 'B': 
					print()
					print("Patente no se encuentra en estado 'Bruto'")
					print()
				else:
					if patente != '0':
						print()
						print("Patente no registrada")
						print()	
	print()
	print()


def reportes():
	print()
	print("----------------------------------------Reportes----------------------------------------")

	#listaAcum()

	cantcup = cantcupos()
	print('Cantidad de cupos otorgados: ',cantcup)
	print()
	cantrec = cantrecs()
	print('Cantidad total de camiones recibidos: ',cantrec)
	print()
	canttotalxprod()
	print()
	pnetoxprod()
	print()
	promxprod()
	patmenor()
	print()


def listsilos():
	print()
	print("Listado de Silos y Rechazos")
	mayorSto = mayorStock()
	print("Silo con Mayor Stock:        ",mayorSto)
	Rechazos()
	print()



### programa principal ###
afOpe = "c:\\Users\\Elias\\ayed\\tp3\\Operaciones.dat"  
afProd = "c:\\Users\\Elias\\ayed\\tp3\\Productos.dat"  
afRub = "c:\\Users\\Elias\\ayed\\tp3\\Rubros.dat"  
afRubxProd = "c:\\Users\\Elias\\ayed\\tp3\\Rubros-X-Producto.dat"  
afSilos = "c:\\Users\\Elias\\ayed\\tp3\\Silos.dat"  
afAcum = "c:\\Users\\Elias\\ayed\\tp3\\Acum.dat" 


##archivo Operaciones
if not os.path.exists(afOpe):   
    alOpe = open(afOpe, "w+b")   
else:
    alOpe = open(afOpe, "r+b")

##archivo Productos
if not os.path.exists(afProd):   
    alProd = open(afProd, "w+b")   
else:
    alProd = open(afProd, "r+b")

##archivo Rubros
if not os.path.exists(afRub):   
    alRub = open(afRub, "w+b")   
else:
    alRub = open(afRub, "r+b")

##archivo Rubros-X-Producto
if not os.path.exists(afRubxProd):   
    alRubxProd = open(afRubxProd, "w+b")   
else:
    alRubxProd = open(afRubxProd, "r+b")

##archivo Silos
if not os.path.exists(afSilos):   
    alSilos = open(afSilos, "w+b")   
else:
    alSilos = open(afSilos, "r+b")

##archivo Acumuladores
if not os.path.exists(afAcum):   
    alAcum = open(afAcum, "w+b")   
else:
    alAcum = open(afAcum, "r+b")


##variables auxiliares
rOpe = Operacion()
rProd = Producto()
rRubro = Rubro()
rRubroxProd = RubroxProd()
rSilo = Silo()
rAcum = Acum()


opcionesmp = "----Menú Principal----\n 1 - ADMINISTRACIONES \n 2 - ENTREGA DE CUPOS \n 3 - RECEPCIÓN \n 4 - REGISTRAR CALIDAD \n " \
 "5 - REGISTRAR PESO BRUTO \n 6 - REGISTRAR DESCARGA \n 7 - REGISTRAR TARA \n 8 - REPORTES \n 9 – LISTADO DE SILOS y RECHAZOS \n " \
 "0 - Fin del Programa" 
opcionesms = "\n A- TITULARES \n B- PRODUCTOS \n C- RUBROS \n D- RUBROS x PRODUCTOS \n " \
 "E- SILOS \n F- SUCURSALES \n G- PRODUCTO x TITULAR \n V- VOLVER AL MENÚ PRINCIPAL \n "
opcionesmt = "\n A. ALTA \n B. BAJA \n C. CONSULTA \n M. MODIFICACIÓN \n V. VOLVER AL MENÚ ANTERIOR "
mc = "\nEsta funcionalidad está en construcción\n"

print(opcionesmp)	
menuprin = input('Elija su opción\n')


while menuprin != '0':
	if (menuprin == '1'):
		administ()
	elif (menuprin == '2'):
		entcupos()
	elif (menuprin == '3'):
		recepcion()
	elif (menuprin == '4'):
		regcalidad()
	elif (menuprin == '5'):
		regpesbruto()
	elif (menuprin == '6'):
		print(mc)
	elif (menuprin == '7'):
		regtara()
	elif (menuprin == '8'):
		reportes()
	elif (menuprin == '9'):
		listsilos()
	else:
		if (menuprin != '0'):
			print('\nOpción Incorrecta. Vuelva a ingresar una opción correcta: \n')
	print(opcionesmp)
	menuprin = input('Elija su opción\n')


##cierre de archivos
alAcum.close()
alProd.close()
alOpe.close()
alRub.close()
alRubxProd.close()
alSilos.close()

print('Fin del Programa')