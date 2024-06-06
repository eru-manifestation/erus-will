;/////////////////// INICIA EL JUEGO 1: LOS DOS ROBAN HASTA TENER 8 CARTAS ////////////////////////
(defmodule start-game-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule standarize-hand
	(object (is-a PLAYER) (hand ?n&:(neq ?n 8)) (name ?p))
	=>
	(make-instance (gen-name EP-standarize-hand) of EP-standarize-hand
		(reason start-game-1::standarize-hand) 
		(target ?p))
	(message ?p " roba hasta tener 8 cartas")
)