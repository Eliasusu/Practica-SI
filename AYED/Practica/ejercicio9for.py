contador = 0 
ventasMayoresACien = 0 
for v in range(1,201):
    importe = int(input('Ingresar el importe: '))
    if importe < 100:
        contador += 1 
    else: 
        ventasMayoresACien +=importe
print(contador)
print(ventasMayoresACien)