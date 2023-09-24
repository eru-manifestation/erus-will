;CREA LOS DOS JUGADORES Y SUS MANOS Y BARAJAS
(defglobal MAIN
	?*player1* = (make-instance (gen-name PLAYER) of PLAYER)
	?*player2* = (make-instance (gen-name PLAYER) of PLAYER)
    ;TODO: función para intercambiar jugador actual y enemigo
    ?*player* = ?*player1*
    ?*enemy* = ?*player2*

    ; Escribir nil para no saber de donde viene debug info y t para saber la traza
    ?*debug-traces* = t
    ; Escribir nil para no debug info y t para debug info
    ?*debug-info* = t
)