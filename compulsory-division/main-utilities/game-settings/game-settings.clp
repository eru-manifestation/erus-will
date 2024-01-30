;CREA LOS DOS JUGADORES Y SUS MANOS Y BARAJAS
(defglobal MAIN
	?*player1* = (make-instance (gen-name PLAYER) of PLAYER)
	?*player2* = (make-instance (gen-name PLAYER) of PLAYER)
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
        (case [player1] then [PLAYERHAND])
        (case [player2] then [ENEMYHAND])
        (default FALSE)
    )
)

(deffunction drawsymbol (?player)
    (switch ?player
        (case [player1] then [PLAYERDRAW])
        (case [player2] then [ENEMYDRAW])
        (default FALSE)
    )
)

(deffunction discardsymbol (?player)
    (switch ?player
        (case [player1] then [PLAYERDISCARD])
        (case [player2] then [ENEMYDISCARD])
        (default FALSE)
    )
)

(deffunction mpsymbol (?player)
    (switch ?player
        (case [player1] then [PLAYERMP])
        (case [player2] then [ENEMYMP])
        (default FALSE)
    )
)

