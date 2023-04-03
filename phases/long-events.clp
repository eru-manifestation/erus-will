; Primero, descarta tus recursos de suceso duradero que estén en
; juego, después puedes jugar recursos de suceso duradero de tu
; mano. Finalmente, descarta las adversidades de suceso duradero
; de tu oponente.

; DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule R-LONG-EVENT-discard (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 2 1 1))
	
	; Dado un rec suceso duradero tuyo
	(object (is-a R-LONG-EVENT) (name ?le) (player ?p))
	=>
	(gen-event R-LONG-EVENT-discard 
		target ?le)
)


; JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule R-LONG-EVENT-play (declare (salience ?*action-population-salience*))
	(logical
		; Estamos en la fase correcta
		(phase (player ?p) (stage 2 2 1))
		
		; Dado un suceso duradero en la mano del jugador
		(object (is-a R-LONG-EVENT) (name ?rle) (player ?p))
		(object (is-a HAND) (name ?hand) (player ?p))
		(in (over ?hand) (under ?rle))
	)
	=>
	(gen-action R-LONG-EVENT-play ?p 
		target ?rle)
)


; DESCARTAR ADVERSIDADES DE SUCESO DURADERO
(defrule A-LONG-EVENT-discard (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 2 3 1))
		
	; Dado una adversidad suceso duradero del contrincante
	(object (is-a A-LONG-EVENT) (name ?le) (player ?p2&:(eq ?p (enemy ?p))))
	=>
	(gen-event A-LONG-EVENT-discard target ?le)
)
