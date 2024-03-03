;/////////////////// STRIKE 3 1: LANZAR LOS DADOS ////////////////////////
(defmodule strike-3-1 (import MAIN ?ALL) (import strike-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule roll-dices
	=>
	(assert (data (phase strike) (data dices (+ (random 1 6) (random 1 6)))))
)

(defrule punish-hindered
	?f1 <- (data (phase strike) (data dices ?n))
	?f2 <- (data (phase strike) (data unpunished-hindered))
	=>
	(retract ?f1 ?f2)
	(assert (data (phase strike) (data dices (- ?n 3))) (data (phase strike) (data hindered)))
	(message "El golpe se afronta con -3 de poder para reservar fuerzas")
)

(defrule punish-tapped
	?f1 <- (data (phase strike) (data dices ?n))
	(data (phase strike) (data target ?char))
	(not (data (phase strike) (data punish-tapped)))
	(test (eq TAPPED (send ?char get-state)))
	=>
	(retract ?f1)
	(assert (data (phase strike) (data dices (- ?n 1))) 
		(data (phase strike) (data punish-tapped)))
	(message "El golpe se afronta con -1 de poder porque el personaje esta cansado")
)

(defrule punish-wounded
	?f1 <- (data (phase strike) (data dices ?n))
	(data (phase strike) (data target ?char))
	(not (data (phase strike) (data punish-wounded)))
	(test (eq WOUNDED (send ?char get-state)))
	=>
	(retract ?f1)
	(assert (data (phase strike) (data dices (- ?n 1))) 
		(data (phase strike) (data punish-wounded)))
	(message "El golpe se afronta con -2 de poder porque el personaje esta herido")
)

(defrule punish-additional
	?f1 <- (data (phase strike) (data dices ?n))
	?f2 <- (data (phase strike) (data additional))
	=>
	(retract ?f1 ?f2)
	(assert (data (phase strike) (data dices (- ?n 1))))
	(message "El golpe se afronta con -1 de poder porque el personaje ya ha recibido otro golpe")
)