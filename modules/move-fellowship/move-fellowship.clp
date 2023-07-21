;////////////// FASE 0: INICIO MOVER COMPAÑÍA ////////////////////////

;////////////// FASE 1 0: INICIO ROBAR CARTAS SEGÚN MOVIMIENTO ////////////////////////

;////////////// FASE 1 1: EJECUCIÓN MOVER COMPAÑÍA ////////////////////////

; ROBA CARTAS AL MOVER (SI EFECTIVAMENTE SE MUEVE)
(defrule MOVE-FELLOWSHIP::FELLOWSHIP-draw-on-move
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*phase-salience*)))
	; Estamos en la fase correcta
	(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
		(priority ?pr&:(eq ?pr (gen-# EVENT-PHASE))) (name ?e) (stage 1 1)
		(fell ?fell) (from ?from))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))
	(object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
		(name ?event&:(eq ?fell (send ?event get-data fell))))
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
	(gen-event HAND-multiple-draw player ?p max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?p) max ?enemy-draw-limit)
)


; ROBA CARTAS AL QUEDARSE
(defrule MOVE-FELLOWSHIP::FELLOWSHIP-draw-on-stay
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*phase-salience*)))
	; Estamos en la fase correcta
	(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
		(priority ?pr&:(eq ?pr (gen-# EVENT-PHASE))) (name ?e) (stage 1 1)
		(fell ?fell) (from ?from))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))

	; No existe evento que defina movimiento
	(not (object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
		(name ?event&:(eq ?fell (send ?event get-data fell)))))
	=>
	; Si no me muevo, robo siempre según el lugar donde estoy
	(bind ?player-draw-limit (send ?from get-player-draw))
	(bind ?enemy-draw-limit (send ?from get-enemy-draw))

	; Como mínimo, cada jugador debe robar una carta
	(gen-event HAND-draw player ?p)
	(gen-event HAND-draw player (enemy ?p))
	(gen-event HAND-multiple-draw player ?p max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?p) max ?enemy-draw-limit)
)

;////////////// FASE 1 2: FIN ROBAR CARTAS SEGÚN MOVIMIENTO ////////////////////////

;////////////// FASE 2 0: INICIO OPONENTE JUEGA ADVERSIDADES Y CeG ////////////////////////

;////////////// FASE 2 1: EJECUCIÓN OPONENTE JUEGA ADVERSIDADES Y CeG ////////////////////////

; PONER CARTAS EN GUARDIA (SI REALMENTE SE MUEVE)
(defrule MOVE-FELLOWSHIP::ACTION-guard-card-move
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*action-population-salience*)))
	(logical
		; Estamos en la fase adecuada
		(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
			(priority ?pr&:(eq ?pr (gen-# EVENT-PHASE))) (name ?e) (stage 2 1)
			(fell ?fell) (from ?from))
		
		; Puedes tirar un farol, cualquier carta puede ser puesta en guarda
		(object (is-a CARD) (player ?enemy&:(eq ?enemy (enemy ?p)))
			(name ?card))
		
		; Localiza el evento que define el movimiento
		(object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
			(name ?e&:(eq ?fell (send ?e get-data fell))))
	)
	=>
	(gen-action LOCATION-ward guard ?card location (send ?e get-data to))
)


; PONER CARTAS EN GUARDIA SI PERMANECE
(defrule MOVE-FELLOWSHIP::ACTION-guard-card-stay
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*action-population-salience*)))
	(logical
		; Estamos en la fase adecuada
		(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
			(priority ?pr&:(eq ?pr (gen-# EVENT-PHASE))) (name ?e) (stage 2 1)
			(fell ?fell) (from ?from))
		
		; Puedes tirar un farol, cualquier carta puede ser puesta en guarda
		(object (is-a CARD) (player ?enemy&:(eq ?enemy (enemy ?p)))
			(name ?card))
		
		; Verifca que no haya evento que define el movimiento (permanece)
		(not (object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
			(name ?e&:(eq ?fell (send ?e get-data fell)))))
	)
	=>
	(gen-action LOCATION-ward guard ?card location ?from)
)

;TODO: Reglas de jugar adversidades básicas (criaturas)
; Investigar donde se pueden jugar adversidades de suceso duradero, breves y permanentes

;////////////// FASE 2 2: FIN OPONENTE JUEGA ADVERSIDADES Y CeG ////////////////////////

;////////////// FASE 3 0: INICIO CAMBIAR LUGAR ////////////////////////

;////////////// FASE 3 1: EJECUCIÓN CAMBIAR LUGAR ////////////////////////

; CAMBIAR DE LUGAR SI SE MUEVE (event handler)
(defrule MOVE-FELLOWSHIP::fellowship-move-handler 
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*event-handler-salience*)))
	; Estamos en la fase correcta
	(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
		(priority ?pr&:(eq ?pr (gen-# EVENT-PHASE))) (name ?e) (stage 3 1)
		(fell ?fell) (from ?from))

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



;////////////// FASE 3 2: FIN CAMBIAR LUGAR ////////////////////////

;////////////// FASE 4 0: INICIO REPONER AMBAS MANOS ////////////////////////

;////////////// FASE 4 1: EJECUCIÓN REPONER AMBAS MANOS ////////////////////////

; DESCARTAR/ROBAR HASTA TENER LA MANO REFILLEADA
(defrule MOVE-FELLOWSHIP::refill-hand 
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*phase-salience*)))
	; Estamos en la fase correcta
	(object (is-a MOVE-FELLOWSHIP-EP) (type IN) (player ?p)
		(priority ?pr&:(eq ?pr (gen-# MOVE-FELLOWSHIP-EP))) (name ?e) (stage 4 1))
	=>
	; TODO: descartar cartas extra????

	; Relleno las manos de ambos jugadores
	(gen-event HAND-refill player ?p)
	(gen-event HAND-refill player (enemy ?p))
)


;////////////// FASE 4 2: FIN REPONER AMBAS MANOS ////////////////////////

;////////////// FASE 5: FIN MOVER COMPAÑÍAS ////////////////////////

;////////////// RELOJ DEL MÓDULO ////////////////////////

; JUMP BACKWARDS (MODULE)
(deffunction MOVE-FELLOWSHIP::jump-back (?e)
	(send ?e complete)
	(pop-focus)
)

; FUNCION ESQUEMA DE FASES
(deffunction MOVE-FELLOWSHIP::module-guide (?e $?stage)
	(switch ?stage
		(case (create$ 0) then (create$ 1 0))
		(case (create$ 1 2) then (create$ 2 0))
		(case (create$ 2 2) then (create$ 3 0))
		(case (create$ 3 2) then (create$ 4 0))
		(case (create$ 4 2) then (create$ 5))
		
		(case (create$ 5) then (jump-back ?e))
		(default FALSE))
)

; REGLA DE FLUJO DE FASE DENTRO DE UN TURNO
(defrule MOVE-FELLOWSHIP::clock
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*clock-salience*)))
	?e <- (object (is-a MOVE-FELLOWSHIP-EP) (type IN)
		(priority ?p&:(eq ?p (gen-# MOVE-FELLOWSHIP-EP))) (stage $?xs ?x))
	=>
	(bind ?jump-stage (stage-guide $?xs ?x))
	(if ?jump-stage then
		(modify ?e (stage ?jump-stage))
		else
		(modify ?e (stage $?xs (+ 1 ?x)))
	)
)