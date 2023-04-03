
(defrule FELLOWSHIP-draw-on-stay-DEPRECATED
	; Estamos en la fase correcta
	(phase (player ?p) (stage $? move-fellowship ?f 1 1))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))
	=>
	(bind ?player-draw-limit 0)
	(bind ?enemy-draw-limit 0)
	; Si se mueve a un no refugio, el límite lo decide el destino
	(do-for-instance ((?event EVENT))
		(and
			(eq ?event:event-descriptor FELLOWSHIP-move)
			(eq ?event:type IN)
			(eq ?f (send ?event get-data fell)) 
		)
		(bind ?player-draw-limit (send (send ?event get-data to) get-player-draw))
		(bind ?enemy-draw-limit (send (send ?event get-data to) get-enemy-draw))
	)
	
	; Si no se mueve, o lo hace a un refugio, el límite lo decide la localización actual
	(if (neq 0 ?player-draw-limit)
		then
		(bind ?player-draw-limit (send (send ?event get-data from) get-player-draw))
		(bind ?enemy-draw-limit (send (send ?event get-data from) get-enemy-draw))
	)

	; Como mínimo, cada jugador debe robar una carta
	(gen-event HAND-draw player ?p)
	(gen-event HAND-draw player (enemy ?p))
	(gen-event HAND-multiple-draw player ?player max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?player) max ?enemy-draw-limit)
)
	
