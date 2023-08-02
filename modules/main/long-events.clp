; Primero, descarta tus recursos de suceso duradero que estén en
; juego, después puedes jugar recursos de suceso duradero de tu
; mano. Finalmente, descarta las adversidades de suceso duradero
; de tu oponente.

;////////////////// Fase 2 0: INICIO FASE SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 1 0: INICIO DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 1 1: EJECUCION DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////

; EVENTO: DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule MAIN::R-LONG-EVENT-discard (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 2 1 1))
	
	; Dado un rec suceso duradero tuyo
	;TODO: se debe comprobar que este suceso duradero esté en juego
	(object (is-a R-LONG-EVENT) (name ?le) (player ?p))
	=>
	(gen-event R-LONG-EVENT-discard 
		target ?le)
)


;////////////////// Fase 2 1 2: FIN DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 2 0: INICIO JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 2 1: EJECUCION JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////

; ACCIÓN: JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule MAIN::R-LONG-EVENT-play (declare (salience ?*action-population-salience*))
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


;////////////////// Fase 2 2 2: FIN JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 3 0: INICIO DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 3 1: EJECUCION DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////

; EVENTO: DESCARTAR ADVERSIDADES DE SUCESO DURADERO
(defrule MAIN::A-LONG-EVENT-discard (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 2 3 1))
		
	; Dado una adversidad suceso duradero del contrincante
	(object (is-a A-LONG-EVENT) (name ?le) (player ?p2&:(eq ?p (enemy ?p))))
	=>
	(gen-event A-LONG-EVENT-discard target ?le)
)


;////////////////// Fase 2 3 2: FIN DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////

;////////////////// Fase 2 4: FIN DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////
