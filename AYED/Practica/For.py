palabra = input('ingrese una palabra: ').lower()
caracter = input('ingrese caracter a buscar = ').lower()

#!len() funcion que me muestra la cantidad de posiciones de una palabra
#!range() funcion que muestra los numeros de las posiciones de una palabra
'''len(palabra)
range(len(palabra))

for i in range(len(palabra)):
    print(palabra[i])
print('Fin')'''

# Una variable que voy a utilizar en un for, debo inicializarla antes
#PROGRAMA CONTADOR DE LETRAS

contador = 0

for i in range(len(palabra)):
    if(palabra[i] == caracter):
        contador += 1
print('La cantidad de igualdades son: ', contador)
