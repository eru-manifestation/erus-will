;/////////////////// FASE 0 2 1: EJECUCION CURAR PERSONAJES EN REFUGIOS ////////////////////////
(defmodule P-0-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Cura personajes en refugios))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; EVENTO: Curar personajes y aliados heridos en refugios que sean del jugador actual
(defrule heal
	(object (is-a WOUNDABLE) (name ?c) (state WOUNDED) (player ?p&:(eq ?p ?*player*)))
	(object (is-a HAVEN) (name ?loc))
	(in (over ?loc) (under ?c))
	=>
	(make-instance (gen-name E-cure) of E-cure (card ?c))
)