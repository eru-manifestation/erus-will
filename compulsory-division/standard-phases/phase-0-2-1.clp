;/////////////////// FASE 0 2 1: EJECUCION CURAR PERSONAJES EN REFUGIOS ////////////////////////
(defmodule P-0-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; EVENTO: Curar personajes y aliados heridos en refugios que sean del jugador actual
(defrule heal
    (player ?p)
	(object (is-a WOUNDABLE) (name ?c) (state WOUNDED) (player ?p))
	(object (is-a HAVEN) (name ?loc))
	(in (over ?loc) (under ?c))
	=>
	(E-modify ?c state UNTAPPED P-0-2-1-heal)
	(message "Curar personajes y aliados heridos en refugios que sean del jugador actual")
)