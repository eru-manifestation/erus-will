;/////////////////// STRIKE 3 2: EJECUTAR GOLPE ////////////////////////
(defmodule strike-3-2 (import MAIN ?ALL) (import strike-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message The strike is being executed))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule execute-strike
	;(object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char) (attackable ?at))
	(target ?char)
	(attackable ?at)
	(dices ?d)
	; (object (is-a CHARACTER) (name ?char))
	; (object (is-a ATTACKABLE) (name ?at))
	=>
	(bind ?prowess (send ?char get-prowess))
	(bind ?at-prowess (send ?at get-prowess))
	(bind ?at-body (send ?at get-body))

	(if (< ?at-prowess (+ ?d ?prowess)) then
		(if (neq ?at-body (slot-default-value ATTACKABLE body)) then
			(assert (enemy-res-check))
		)
		else
		(if (= ?at-prowess (+ ?d ?prowess)) then
			;(send ?ep modify state UNDEFEATED)
			; El golpe no ha sido derrotado
			(assert (cancel))
			else	
			; No se derrota el golpe y se requiere chequeo de resistencia
			(assert (defender-res-check)) 
			(assert (cancel))	
		)
	)
)

(defrule enemy-res-check
	(enemy-res-check)
	(target ?char)
	(attackable ?at)
	=>
	(make-instance (gen-name E-phase) of E-phase
		(reason resistance-check strike-3-2::enemy-res-check)
		(data (str-cat "attacker " ?char) (str-cat "assaulted " ?at)))
)

(defrule defender-res-check
	(defender-res-check)
	(target ?char)
	(attackable ?at)
	=>
	(make-instance (gen-name E-phase) of E-phase
		(reason resistance-check strike-3-2::defneder-res-check)
		(data (str-cat "attacker " ?at) (str-cat "assaulted " ?char)))
)

(defrule cancel
	(object (is-a E-phase) (state EXEC) (name ?e))
	(cancel)
	=>
	(E-cancel ?e strike-3-2::cancel)
)


(defrule tap-unhindered
	; (object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char) (hindered FALSE))
	; (object (is-a CHARACTER) (name ?char) (state UNTAPPED))
	(target ?char)
	(not (hindered))
	=>
	; (send ?char modify state TAPPED)
	(E-modify ?char state TAPPED
		TAP strike-3-2::tap-unhindered)
)