;/////////////////// ATTACK 3: HACER FRENTE AL GOLPE EN EL ORDEN QUE ELIJA EL DEFENSOR ////////////////////////
(defmodule attack-3 (import MAIN ?ALL) (import attack-2-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Player chooses the order in which strikes execute))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-select-strike  (declare (salience ?*action-population*))
	(logical 
		(only-actions (phase attack-3))
    	(player ?p)

		;(object (is-a E-select-strike) (name ?e) (type IN) 
        ;(char ?char) (attackable ?at))
		(attackable ?at)
		(strike ?char)
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Execute strike from " ?at " to " ?char))
		(identifier ?char)
		(data (create$ "strike attack-3::action-select-strike"
			(str-cat "target " ?char) (str-cat "attackable " ?at)))
		(blocking TRUE)
	))
)


(defrule action-select-spare-strike  (declare (salience ?*action-population*))
	(logical 
		(only-actions (phase attack-3))
    	(player ?p)

		;(object (is-a E-select-strike) (name ?e) (type IN) 
        ;(char ?char) (attackable ?at))
		(attackable ?at)
		(spare-strike ?char)
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Execute strike from " ?at " to " ?char))
		(identifier ?char)
		(data (create$ "strike attack-3::action-select-spare-strike"
			(str-cat "target " ?char) (str-cat "attackable " ?at)))
		(blocking TRUE)
	))
)