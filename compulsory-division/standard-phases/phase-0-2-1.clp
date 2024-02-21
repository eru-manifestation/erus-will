;/////////////////// FASE 0 2 1: EJECUCION CURAR PERSONAJES EN REFUGIOS ////////////////////////
(defmodule P-0-2-1 (import MAIN ?ALL) (import P-0-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Cura personajes en refugios))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; EVENTO: Curar personajes y aliados heridos en refugios que sean del jugador actual
(defrule heal
    (player ?p)
	(object (is-a WOUNDABLE) (name ?c) (state WOUNDED) (player ?p))
	(object (is-a HAVEN) (name ?loc))
	(in (over ?loc) (under ?c))
	=>
	(E-modify ?c state UNTAPPED P021-heal)
	(message "Curar personajes y aliados heridos en refugios que sean del jugador actual")
)