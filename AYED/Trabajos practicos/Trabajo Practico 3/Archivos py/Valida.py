from turtle import Turtle


def validarNum(min, max, n):
    x = int(input(f"{n}"))
    while  x >= min and x <= max:
        int(input(f"{n}"))
    return(x)


def validarEntero(min, max, n):
    ok = False
    while not ok:
        x = int(input(f"{n}"))
        if x >= min and x <= max:
            ok = True
        else:
           print('Ingrese un valor correcto, por favor.')
    return x


def validarStr(min, max, n):
    ok = False
    while not ok:
        x = str(input(f"{n}"))
        if x >= min and x <= max:
            ok = True
        else:
           print('Ingrese un valor correcto, por favor.')
    return x


