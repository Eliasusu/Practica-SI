#~Como hacer While y Until en python

#Corte de datos por 0 o '*' WHILE
opcion = int(input('Ingresar Opcion: '))
while opcion != 0:



    opcion = int(input('Ingresar Opcion: '))




#Validacion de un dato entre un min y max UNTIL

documento = input(str('Ingrese su documento: '))
while len(documento) <= 7 or len(documento) >= 9:
#until documento >= 6 and documento <= 8:



    documento = input(str('Documento invalido, Ingrese nuevamente su documento: '))
    

def ValidacionDeEnteros(min, max):
    global valor

    valor = int(input('Ingrese... '))
    while valor <= min or valor >= max:
    #until valor >= min and valor <= max
        valor = int(input('Invalido, ingrese nuevamente... '))


def ValidacionDeCadenas(min, max):
    global cadena
    
    cadena = str(input('Ingrese... '))
    while len(cadena) <= min or len(cadena) >= max:
        cadena = str(input('Invalido, ingrese nuevamente... '))



nombres = [' ']*3

for i in range(3):
    nombres[i] = str(input('Ingrese su nombre: '))

print(nombres)


nombre = str(input('Ingrese el nombre que busca: '))
limite = 2

def BusquedasSecuenciales(valorBuscado, limiteArreglo):
    global flag, posicionEncontrada
    posicionEncontrada = 0
    flag = False
    pos = 0
    while nombres[pos] != valorBuscado and pos != limiteArreglo:
    #until nombres[pos] = nombre or nombres[pos] = limite:
        pos += 1
    if nombres[pos] == valorBuscado:
        flag = True
        posicionEncontrada = pos
    else: 
        flag = False
    return(flag)



def Ordenamiento():
    pass


BusquedasSecuenciales(nombre,limite)

print(flag)
print(nombres)


