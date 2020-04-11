DECLARE SUB InitGame ()
DECLARE SUB DrawBoxGame ()
DECLARE SUB DrawCharacter (OPoint AS ANY, legStatus as integer)
DECLARE SUB DrawBox (oBox AS ANY)
'
' Tipos del Engine
'
'
'
'
TYPE ScreenGame
    Xmax AS INTEGER '640
    Ymax AS INTEGER '480
    Mode AS INTEGER '12
END TYPE

TYPE Point2D
    X AS INTEGER
    Y AS INTEGER
END TYPE

TYPE BoxType
    OPoint AS Point2D 'Origin Point
    Height AS INTEGER
    bWidth AS INTEGER
    BorderColor AS INTEGER
    BackColor AS INTEGER
    Border AS INTEGER
END TYPE

TYPE KeyboardStatus
    IsUp AS INTEGER
    IsDown AS INTEGER
    IsLeft AS INTEGER
    IsRight AS INTEGER
    IsFire AS INTEGER
    IsSomething AS INTEGER
    IsEscape AS INTEGER
END TYPE

DIM nombre AS STRING

DIM SHARED KeyStatus AS KeyboardStatus

CALL InitGame
CALL DrawBoxGame
DIM SHARED CharPoint AS Point2D
DIM SHARED LastCharPoint AS Point2D

CharPoint.X = 240
CharPoint.Y = 240


DIM CharStatus AS INTEGER
CharStatus = 0

'PLAY ("CDEFGABC1")

DO

    CALL ReadKeyboard

    LastCharPoint = CharPoint

    IF (KeyStatus.IsRight) THEN
        CharPoint.X = CharPoint.X + 1
    END IF
    IF (KeyStatus.IsLeft) THEN
        CharPoint.X = CharPoint.X - 1
    END IF
    IF (KeyStatus.IsUp) THEN
        CharPoint.Y = CharPoint.Y - 1
    END IF
    IF (KeyStatus.IsDown) THEN
        CharPoint.Y = CharPoint.Y + 1
    END IF


    IF KeyStatus.IsSomething THEN
        'Cambiar la pierna activa del caracter
        IF CharStatus = 0 THEN
            CharStatus = 1
        ELSE
            CharStatus = 0
        END IF
        CALL DrawCharacter(CharPoint, CharStatus)
    ELSE
        'El caracter esta quieto
        CALL DrawCharacter(CharPoint, 2)
    END IF

    'CALL DrawCircleFilled(LastCharPoint, 10, 10, 14)
    SLEEP (1)

LOOP WHILE KeyStatus.IsEscape = 0



'
'  FUNCIONES DEL ENGINE
'
'
'

SUB DrawBox (oBox AS BoxType)
    'Dibuja una Caja
    IF oBox.Border > 1 THEN
        LINE (oBox.OPoint.X, oBox.OPoint.Y)-(oBox.OPoint.X + oBox.bWidth, oBox.OPoint.Y + oBox.Height), oBox.BorderColor, BF 'creates styled box shape
        LINE (oBox.OPoint.X + oBox.Border, oBox.OPoint.Y + oBox.Border)-(oBox.OPoint.X + oBox.bWidth - oBox.Border, oBox.OPoint.Y + oBox.Height - oBox.Border), oBox.BackColor, BF 'creates styled box shape
    ELSE
        LINE (oBox.OPoint.X, oBox.OPoint.Y)-(oBox.OPoint.X + oBox.bWidth, oBox.OPoint.Y + oBox.Height), oBox.BorderColor, B 'creates styled box shape
    END IF
END SUB

SUB DrawCircle (oPoint AS Point2D, width AS INTEGER, height AS INTEGER)
    'Dinuja un circulo
    CIRCLE (oPoint.X, oPoint.Y), width, height
END SUB

SUB DrawCircleFilled (oPoint AS Point2D, width AS INTEGER, height AS INTEGER, dcolor AS INTEGER)
    'Dinuja un circulo
    CIRCLE (oPoint.X, oPoint.Y), width, height
    'PAINT (oPoint.X, oPoint.Y), dcolor, dcolor 'Falta hacer la conversion
END SUB


SUB DrawBoxGame
    'Dibuja el borde del juego
    DIM oBox AS BoxType
    oBox.OPoint.X = 0
    oBox.OPoint.Y = 0
    oBox.Height = 479
    oBox.bWidth = 639
    oBox.BorderColor = 15
    oBox.Border = 20
    oBox.BackColor = 0
    CALL DrawBox(oBox)
END SUB

SUB DrawCharacter (OPoint AS Point2D, drawLegs AS INTEGER)
    'DrawLegs : 0 Derecha 1 Izquierda 2 Ambas
    'Caja que rodea al personaje (para debug, o para borrar el personaje antes de repintarlo, en funcion de si se usa OPoint o LastCharPoint)
    DIM box AS BoxType
    box.OPoint = LastCharPoint
    box.Height = 10
    box.bWidth = 6
    box.Border = 1
    box.BorderColor = 0
    box.BackColor = 0
    'CALL DrawBox(box) 'Pero no funciona
    CALL DrawBoxGame 'Esto es un poco bruto pero funciona

    'Caja de la Cabeza
    DIM cabeza AS BoxType
    cabeza.OPoint.X = OPoint.X + 1
    cabeza.OPoint.Y = OPoint.Y
    cabeza.Height = 2
    cabeza.bWidth = 4
    cabeza.Border = 1
    cabeza.BorderColor = 15
    CALL DrawBox(cabeza)
    'Linea del cuerpo
    LINE (OPoint.X + 3, OPoint.Y + 2)-(OPoint.X + 3, OPoint.Y + 8), 15
    'Linea Hombros
    LINE (OPoint.X, OPoint.Y + 4)-(cabeza.OPoint.X + 5, OPoint.Y + 4), 15
    'Brazo izquierdo
    LINE (OPoint.X, OPoint.Y + 4)-(OPoint.X, OPoint.Y + 6), 15
    'Brazo Derecho
    LINE (OPoint.X + 6, OPoint.Y + 4)-(OPoint.X + 6, OPoint.Y + 6), 15
    'Pelvis
    LINE (OPoint.X + 1, OPoint.Y + 8)-(OPoint.X + 5, OPoint.Y + 8), 15

    IF drawLegs = 0 THEN
        'Pie Derecho
        LINE (OPoint.X + 1, OPoint.Y + 8)-(OPoint.X + 1, OPoint.Y + 10), 15
    END IF

    IF drawLegs = 1 THEN
        'Pie Izquierdo
        LINE (OPoint.X + 5, OPoint.Y + 8)-(OPoint.X + 5, OPoint.Y + 10), 15
    END IF

    IF drawLegs = 2 THEN
        'Pie Derecho
        LINE (OPoint.X + 1, OPoint.Y + 8)-(OPoint.X + 1, OPoint.Y + 10), 15
        'Pie Izquierdo
        LINE (OPoint.X + 5, OPoint.Y + 8)-(OPoint.X + 5, OPoint.Y + 10), 15
    END IF

END SUB

'
'  FUNCIONES DEL GAME
'
'
'
SUB InitGame
    'Inicializa el Juego
    STATIC GameScreen AS ScreenGame
    GameScreen.Xmax = 640
    GameScreen.Ymax = 480
    GameScreen.Mode = 12


    'Esto iria lo ultimo en la inicializacion
    SCREEN GameScreen.Mode
END SUB

SUB ReadKeyboard
    c$ = INKEY$ 'Lee el buffer de teclado por FIFO

    KeyStatus.IsUp = 0
    KeyStatus.IsDown = 0
    KeyStatus.IsRight = 0
    KeyStatus.IsLeft = 0
    KeyStatus.IsFire = 0
    KeyStatus.IsEscape = 0
    KeyStatus.IsSomething = 0

    IF LCASE$(c$) = "w" THEN
        KeyStatus.IsUp = 1
        KeyStatus.IsSomething = 1
    END IF
    IF LCASE$(c$) = "s" THEN
        KeyStatus.IsDown = 1
        KeyStatus.IsSomething = 1
    END IF
    IF LCASE$(c$) = "a" THEN
        KeyStatus.IsLeft = 1
        KeyStatus.IsSomething = 1
    END IF
    IF LCASE$(c$) = "d" THEN
        KeyStatus.IsRight = 1
        KeyStatus.IsSomething = 1
    END IF
    IF c$ = CHR$(34) THEN
        KeyStatus.IsFire = 1
        KeyStatus.IsSomething = 1
    END IF
    IF c$ = CHR$(27) THEN
        KeyStatus.IsEscape = 1
        KeyStatus.IsSomething = 1
    END IF

END SUB

