;CREA LOS DOS JUGADORES Y SUS MANOS Y BARAJAS
(defglobal TOOLS
	?*player1* = (make-instance (gen-name PLAYER) of PLAYER)
	?*player2* = (make-instance (gen-name PLAYER) of PLAYER)
	?*draw-deck1* = (make-instance (gen-name DECK) of DECK (player ?*player1*))
	?*draw-deck2* = (make-instance (gen-name DECK) of DECK (player ?*player2*))
	?*hand1* = (make-instance (gen-name HAND) of HAND (player ?*player1*))
	?*hand2* = (make-instance (gen-name HAND) of HAND (player ?*player2*))

    ; Activa o desactiva la función de casting
    ?*cast-activated* = TRUE
)