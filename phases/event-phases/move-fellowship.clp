; ROBA CARTAS AL MOVER (SI EFECTIVAMENTE SE MUEVE)
(defrule FELLOWSHIP-draw-on-move (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $? move-fellowship ?f ?from 1 1))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))
	(object (is-a EVENT) (event-descriptor FELLOWSHIP-move) (type IN)
		(name ?event&:(eq ?f (send ?event get-data fell))))
	=>
	(bind ?to (send ?event get-data to))
	(if (send ?to is-haven) then
		; Si vas a un refugio, robas según el punto de partida
		(bind ?player-draw-limit (send ?from get-player-draw))
		(bind ?enemy-draw-limit (send ?from get-enemy-draw))
		else
		(bind ?player-draw-limit (send ?to get-player-draw))
		(bind ?enemy-draw-limit (send ?to get-enemy-draw))
	)

	; Como mínimo, cada jugador debe robar una carta
	(gen-event HAND-draw player ?p)
	(gen-event HAND-draw player (enemy ?p))
	(gen-event HAND-multiple-draw player ?player max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?player) max ?enemy-draw-limit)
)

; ROBA CARTAS AL QUEDARSE
(defrule FELLOWSHIP-draw-on-stay (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $? move-fellowship ?f ?from 1 1))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))

	; No existe evento que defina movimiento
	(not (object (is-a EVENT) (event-descriptor FELLOWSHIP-move) (type IN)
		(name ?event&:(eq ?f (send ?event get-data fell)))))
	=>
	; Si no me muevo, robo siempre según el lugar donde estoy
	(bind ?player-draw-limit (send ?from get-player-draw))
	(bind ?enemy-draw-limit (send ?from get-enemy-draw))

	; Como mínimo, cada jugador debe robar una carta
	(gen-event HAND-draw player ?p)
	(gen-event HAND-draw player (enemy ?p))
	(gen-event HAND-multiple-draw player ?player max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?player) max ?enemy-draw-limit)
)

; PONER CARTAS EN GUARDIA (SI REALMENTE SE MUEVE)
(defrule ACTION-guard-card-move (declare (salience ?*action-population-salience*))
	(logical
		; Estamos en la fase adecuada
		(phase (player ?p) (stage $? move-fellowship ?f ?from 2 1))
		
		; Puedes tirar un farol, cualquier carta puede ser puesta en guarda
		(object (is-a CARD) (player ?enemy&:(eq ?enemy (enemy ?p)))
			(name ?card))
		
		; Localiza el evento que define el movimiento
		(object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
			(name ?e&:(eq ?f (send ?e get-data fell))))
	)
	=>
	(gen-action LOCATION-ward guard ?card location (send ?e get-data to))
)

; PONER CARTAS EN GUARDIA SI PERMANECE
(defrule ACTION-guard-card-stay (declare (salience ?*action-population-salience*))
	(logical
		; Estamos en la fase adecuada
		(phase (player ?p) (stage $? move-fellowship ?f ?from 2 1))
		
		; Puedes tirar un farol, cualquier carta puede ser puesta en guarda
		(object (is-a CARD) (player ?enemy&:(eq ?enemy (enemy ?p)))
			(name ?card))
		
		; Verifca que no haya evento que define el movimiento (permanece)
		(not (object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
			(name ?e&:(eq ?f (send ?e get-data fell)))))
	)
	=>
	(gen-action LOCATION-ward guard ?card location ?from)
)

; CAMBIAR DE LUGAR SI SE MUEVE (event handler)
(defrule fellowship-move-handler (declare (salience ?*event-handler-salience*))
	; Estamos en la fase correcta
	(phase (stage $? move-fellowship ?fell ?from 3 1))

	; Localizo el evento de movimiento
	(object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN) 
		(name ?e&:(eq ?fell (send ?e get-data fell))))

	; Localizo el hecho inicial que indica donde esta la compañia
	?in <- (in (over ?from) (under ?fell))
	=>
	; Retracto la posición inicial de la compañía y aserto la nueva posición
	(retract ?in)
	(assert (in (over (send ?e get-data to)) (under ?fell)))
)


; DESCARTAR/ROBAR HASTA TENER LA MANO REFILLEADA
(defrule refill-hand (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $? move-fellowship ?fell ?from 4 1))
	=>
	; Relleno las manos de ambos jugadores
	(gen-event HAND-refill player ?p)
	(gen-event HAND-refill player (enemy ?p))
)


; JUMP BACKWARDS (salta de vuelta a donde estaba el programa)
(defrule move-jump-back (declare (salience ?*jump-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $?pre-stage move-fellowship ? ? 5))
	=>
	(jump $?pre-stage)
)