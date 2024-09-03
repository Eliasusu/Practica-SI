#Menu de opciones 

print('Elija una opción: \n 1: Alta \n 2: Baja \n 3: Consulta \n 4: Modificación \n 0: Volver al menú anterior')

#Variable del menu de opciones 
opMenuop = int(input('Elija una opción: '))

while not opMenuop >= 0 and opMenuop <= 5:
    opMenuop = int(input('Elija una opción: '))
if opMenuop == 1:
    print('Esta opción no ha sido configurada')
elif opMenuop == 2:
    print('Esta opción no ha sido configurada')
elif opMenuop == 3:
    print('Esta opción no ha sido configurada')
elif opMenuop == 4:
    print('Esta opción no ha sido configurada')
elif opMenuop == 0:
    import menuAdministracion

