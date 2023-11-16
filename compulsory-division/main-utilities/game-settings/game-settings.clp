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

    ?*announce-p1* = (create$)
    ?*announce-p2* = (create$)
    ?*debug* = (create$)
    ?*debug-state* = FALSE
    ?*choose-p1* = (create$)
    ?*choose-p2* = (create$)

    ?*state-p1* = (create$)
    ?*state-p2* = (create$)
)

