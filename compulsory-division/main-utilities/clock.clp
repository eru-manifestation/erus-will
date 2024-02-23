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
				;(message Fin de la partida);PUEDE QUE SEA NECESARIO PQ NUNCA OCURRA
				;(halt)
				(update-only-actions MAIN)
				else
				(update-only-actions (nth$ 3 (get-focus-stack)))
			)
			else 
			(update-only-actions (nth$ 2 (get-focus-stack)))
		)

		;TODO: sustituir la regla ini por un mapa (switch) que imprima el mensaje de entrada conveniente y que refresque las reglas del modulo, ya que cambiando el foco basta para conseguirlo
		; Probar con (focus <module-name>) o (set-current-module <module-name>)
		;(message Reglas: (get-defrule-list))
		(object-pattern-match-delay 
			(focus ?stage)
			(foreach ?rule (get-defrule-list) (refresh ?rule))
			(foreach ?deftemplate (get-deftemplate-list)
				(do-for-all-facts ((?f ?deftemplate)) TRUE
					(retract ?f)
				)
			)
			(pop-focus)
		)

		; TODO: Cuidado al retractar hechos que sean heredados de MAIN. De la misma forma, solo se deben retractar los hechos del modulo final de una E-phase, ya que supongo que se retractarian los hechos de la E-phase al completo. Hacer esto cuando se de un salto a una E-phase, no cuando se de un tick del reloj ¡¡IMPORTANTE!!
		; Mejor encontrar la deftemplate list e iterar sobre ella en cada uno de los modulos. Eliminamos todos los hechos y despues eliminamos la deftemplate con (undeftemplate <deftemplate-name>)
		; ¡¡¡¡¡IMPORTANTISIMO!!!!! Ahora mismo, se genera el deftemplate de data antes de eliminar los desperdicios anteriores. Por tanto, hacer la limpieza AL SALIR DE LA FASE, para evitar conflictos de prioridades en crear y limpiar deftemplates.
		;(message Hechos: (get-deftemplate-list ?stage))

		(do-for-instance ((?ep E-phase)) (eq EXEC ?ep:state)
			(send ?ep modify state DONE)
		)
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
		(reason turn MAIN::next-turn) (data (str-cat "target [" ?e "]")))
)