cont = 0
poblacionA = 52
poblacionB = 85

while not poblacionB < poblacionA:
    cont += 1
    poblacionA += 5.1
    poblacionB += 3.1
    print('Poblacion de A', poblacionA)
    print('Poblacion de B', poblacionB)
print('Poblacion de A', poblacionA)
print('Poblacion de B', poblacionB)
print('Años transcurridos', cont)