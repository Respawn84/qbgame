DECLARE SUB Mover ()
DECLARE SUB MostrarMapa ()
DECLARE SUB ActualizaHUD (n as integer, v as integer, s as integer)

DIM SHARED GamePath AS STRING
DIM SHARED COL AS INTEGER
DIM SHARED ROW AS INTEGER
DIM SHARED LastRow AS INTEGER
DIM SHARED LastCol AS INTEGER
DIM SHARED PressKey AS STRING
DIM SHARED LastKey AS STRING
DIM SHARED ActualLevel AS STRING
DIM SHARED CurrentMap(25) AS STRING


GamePath = "D:\GameDev"
ActualLevel = "1"
COL = 3
ROW = 16
LastRow = COL
LastCol = ROW

SCREEN 9, 1, 1, 1
CALL CargarMapa("1")

CALL ActualizaHUD(3, 3, 3, 1)
CALL MostrarMapa

DO

    IF PressKey = "W" OR PressKey = "S" OR PressKey = "A" OR PressKey = "D" THEN

        CALL MostrarMapa

    END IF

    PressKey = INKEY$
    CALL Mover

LOOP UNTIL PressKey = CHR$(27)



SUB CargarMapa (level AS STRING)
    'Carga el mapa del fichero al array del mapa
    OPEN GamePath + "\Level" + level + "\mapa.txt" FOR INPUT AS #1
    DIM i AS INTEGER
    i = 0
    DO
        LINE INPUT #1, l$
        CurrentMap(i) = l$
        i = i + 1
    LOOP UNTIL (EOF(1))
    CLOSE #1

    OPEN GamePath + "\Common\hud.txt" FOR INPUT AS #2
    DO
        LINE INPUT #2, l$
        CurrentMap(i) = l$
        i = i + 1
    LOOP UNTIL (EOF(2))
    CLOSE #2

END SUB

SUB MostrarMapa
    'Muestra por pantalla el mapa
    LOCATE 1, 1
    FOR i = 1 TO 22
        PRINT CurrentMap(i)
        LOCATE i, 1
    NEXT
    LOCATE ROW, COL
END SUB

SUB ActualizaHUD (vida AS INTEGER, vidas AS INTEGER, disparos AS INTEGER, score AS INTEGER)

    DIM st AS STRING
    FOR i = 1 TO 10
        IF i <= vida THEN
            st = st + ""
        ELSE
            st = st + " "
        END IF
    NEXT

    DIM st2 AS STRING
    FOR i = 1 TO 5
        IF i <= vidas THEN
            st2 = st2 + ""
        ELSE
            st2 = st2 + " "
        END IF
    NEXT

    DIM st3 AS STRING
    FOR i = 1 TO 10
        IF i <= vidas THEN
            st3 = st3 + "*"
        ELSE
            st3 = st3 + " "
        END IF
    NEXT


    DIM linea AS STRING
    linea = CurrentMap(21)
    linea = "Û  [" + st + "]   [" + st2 + "]     [" + st3 + "]                 SCR: [000000] Û"
    CurrentMap(21) = linea

END SUB


SUB Mover

    IF PressKey = "W" THEN
        LastRow = ROW
        ROW = ROW - 1
    END IF

    IF PressKey = "S" THEN
        LastRow = ROW
        ROW = ROW + 1
    END IF

    IF PressKey = "A" THEN
        LastCol = COL
        COL = COL - 1
    END IF

    IF PressKey = "D" THEN
        LastCol = COL
        COL = COL + 1
    END IF

    IF SCREEN(ROW, COL) = 219 THEN
        BEEP
        ROW = LastRow
        COL = LastCol
    END IF

    REM PRINT CHR$(32) REM ELIMINAR EL CARACTER ACTUAL
    LOCATE ROW, COL
    PRINT CHR$(1)

END SUB

