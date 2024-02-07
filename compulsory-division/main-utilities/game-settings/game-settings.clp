;CREA LOS DOS JUGADORES Y SUS MANOS Y BARAJAS
(defglobal MAIN
	?*player1* = (make-instance (gen-name PLAYER) of PLAYER)
	?*player2* = (make-instance (gen-name PLAYER) of PLAYER)

    ?*hand1* = (make-instance hand1 of STACK (player ?*player1*))
    ?*hand2* = (make-instance hand2 of STACK (player ?*player2*))

    ?*draw1* = (make-instance draw1 of STACK (player ?*player1*))
    ?*draw2* = (make-instance draw2 of STACK (player ?*player2*))

    ?*discard1* = (make-instance discard1 of STACK (player ?*player1*))
    ?*discard2* = (make-instance discard2 of STACK (player ?*player2*))

    ?*mp1* = (make-instance mp1 of STACK (player ?*player1*))
    ?*mp2* = (make-instance mp2 of STACK (player ?*player2*))

    ?*out-of-game1* = (make-instance out-of-game1 of STACK (player ?*player1*))
    ?*out-of-game2* = (make-instance out-of-game2 of STACK (player ?*player2*))

    
    ;TODO: Para cuando acabe el turno, función para intercambiar jugador actual y enemigo

    ; IMPORTANTE: intercambiarse entre jugador y enemigos NO va a disparar el PATTERN MATCHING ENGINE
    ; ?*player* = ?*player1*
    ; ?*enemy* = ?*player2*

    ; ; Escribir nil para no saber de donde viene debug info y t para saber la traza
    ; ?*debug-traces* = t
    ; ; Escribir nil para no debug info y t para debug info
    ; ?*debug-info* = t

)

(deffunction handsymbol (?player)
    (switch ?player
        (case [player1] then ?*hand1*)
        (case [player2] then ?*hand2*)
        (default FALSE)
    )
)

(deffunction drawsymbol (?player)
    (switch ?player
        (case [player1] then ?*draw1*)
        (case [player2] then ?*draw2*)
        (default FALSE)
    )
)

(deffunction discardsymbol (?player)
    (switch ?player
        (case [player1] then ?*discard1*)
        (case [player2] then ?*discard2*)
        (default FALSE)
    )
)

(deffunction mpsymbol (?player)
    (switch ?player
        (case [player1] then ?*mp1*)
        (case [player2] then ?*mp2*)
        (default FALSE)
    )
)

(deffunction outofgamesymbol (?player)
    (switch ?player
        (case [player1] then ?*out-of-game1*)
        (case [player2] then ?*out-of-game2*)
        (default FALSE)
    )
)

