; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic (?stage)
	;	TODO: es innecesario pedir ?stage por parametros
	(bind ?stage (get-focus))

	; ACTUALIZA FOCOS
	(bind ?jump-stage (stage-guide ?stage))
	(if ?jump-stage then
		(pop-focus)
		(jump ?jump-stage)
		else
		(if (eq (nth$ 2 (get-focus-stack)) MAIN) then
			(if (< (length$ (get-focus-stack)) 3) then 
				(message Fin de la partida);PUEDE QUE SEA NECESARIO PQ NUNCA OCURRA
				(halt)
				else
				(update-only-actions (nth$ 3 (get-focus-stack)))
			)
			else 
			(update-only-actions (nth$ 2 (get-focus-stack)))
		)

		(do-for-instance ((?ep E-phase)) (eq EXEC ?ep:state)
			(send ?ep modify state DONE)
		)
	)
	
	; ELIMINA EVENTOS O FASES EVENTUALES TERMINADAS
	(do-for-all-instances ((?e EVENT)) 
		(and 
			(eq ?e:type OUT) 
			(not (str-index ?e:target-phase (implode$ (get-focus-stack))))
		)
		(message DELETING ?e)
		(send ?e delete)
	)
)



; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	(assert (only-actions (phase FALSE)))
	;(tic 1)
	;	TODO: intercambiar el hecho player y enemy por las variables de la fase eventual turn
	(assert (infinite) (player ?*player1*) (enemy ?*player2*))

	(make-instance (gen-name E-phase) of E-phase (reason start-game MAIN::start))
	(message Start game)
)
;(defrule MAIN::infiniterule (declare (salience 100)) ?c<-(infinite) => (retract ?c) (assert (infinite)))

(defrule MAIN::start-turn (declare (auto-focus TRUE) (salience -100))
	(object (is-a E-phase) (reason $? MAIN::start) (state DONE))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason turn MAIN::start-turn) 
		(data "player [player1]"))	
)

(defrule MAIN::next-turn (declare (auto-focus TRUE) (salience -100))
	(object (is-a E-phase) (reason $? MAIN::start-turn) (state DONE))
	?f1 <- (player ?p)
	?f2 <- (enemy ?e)
	; Necesario el hecho (player ?p) para hacer las veces de una variable que estaria en el modulo de la fase eventual padre a "turn"
	=>
	(assert (player ?e) (enemy ?p))
	(retract ?f1 ?f2)
	(make-instance (gen-name E-phase) of E-phase 
		(reason turn MAIN::next-turn) (data (str-cat "player " ?e)))
)