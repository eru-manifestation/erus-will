; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic ()
	;	TODO: es innecesario pedir ?stage por parametros
	(bind ?stage (get-focus))

	; ACTUALIZA FOCOS
	(bind ?jump-stage (stage-guide ?stage))
	(if ?jump-stage then
		(pop-focus)
		(jump ?jump-stage)
		else
		; (do-for-instance ((?ep E-phase)) (eq EXEC ?ep:state)
		; 	(send ?ep modify state OUT)
		; )
		(complete FINISHED)
	)
	
	; ELIMINA EVENTOS O FASES EVENTUALES TERMINADAS
	; (do-for-all-instances ((?e EVENT)) 
	; 	(and 
	; 		(eq ?e:state DONE) 
	; 		(not (str-index ?e:target-phase (implode$ (get-focus-stack))))
	; 	)
	; 	(message DELETING ?e)
	; 	(send ?e delete)
	; )
)



; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	;(tic 1)
	;	TODO: intercambiar el hecho player y enemy por las variables de la fase eventual turn
	(assert (infinite) (player ?*player1*) (enemy ?*player2*))

	(make-instance (gen-name E-phase) of E-phase (reason start-game MAIN::start))
	(message Start game)
)
;(defrule MAIN::infiniterule (declare (salience 100)) ?c<-(infinite) => (retract ?c) (assert (infinite)))

(defrule MAIN::start-turn
	(object (is-a E-phase) (reason $? MAIN::start) (state DONE))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason turn MAIN::start-turn) 
		(data player [player1]))	
)

(defrule MAIN::next-turn
	(object (is-a E-phase) (reason $? MAIN::start-turn) (state DONE))
	; Necesario el hecho (player ?p) para hacer las veces de una variable que estaria en el modulo de la fase eventual padre a "turn"
	=>
	(do-for-fact ((?e enemy)) TRUE
		(do-for-fact ((?p player)) TRUE
			(assert (player ?e:implied) (enemy ?p:implied))
			(make-instance (gen-name E-phase) of E-phase 
				(reason turn MAIN::next-turn) (data target (nth$ 1 ?e:implied)))
			(retract ?e ?p)
		)
	)
)