;/////////////////// INICIA EL JUEGO 1: LOS DOS ROBAN HASTA TENER 8 CARTAS ////////////////////////
(defmodule start-game-1 (import MAIN ?ALL) (import start-game-0 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule standarize-hand
	(object (is-a PLAYER) (hand ?n&:(neq ?n 8)) (name ?p))
	=>
	(make-instance (gen-name E-phase) of E-phase
		(reason standarize-hand start-game-1::standarize-hand) 
		(data target ?p))
	(message ?p " roba hasta tener 8 cartas")
)