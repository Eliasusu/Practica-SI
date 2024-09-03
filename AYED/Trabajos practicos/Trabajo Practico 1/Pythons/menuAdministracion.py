#Menu secundario 
#Administraciones
print('Bienvenido, estas son las opciones: \n 1: Titulares \n 2: Productos \n 3: Rubros  \n 4: Rubros x producto \n 5: Silos \n 6: Sucursales \n 7: Producto por titular \n 0: Volver al menu principal')

#Variable para el menu secundario

op2menu = int(input('Elija una opción: '))

while not op2menu >= 0 and op2menu <= 7:
    op2menu = int(input('Elija una opción: '))
if op2menu == 1:
    import menuOpciones
elif op2menu == 2:
    import menuOpciones
elif op2menu == 3:
    import menuOpciones
elif op2menu == 4:
    import menuOpciones
elif op2menu == 5:
    import menuOpciones
elif op2menu == 6:
    import menuOpciones
elif op2menu == 7:
    import menuOpciones
elif op2menu == 0:
    import menuPrincipal
