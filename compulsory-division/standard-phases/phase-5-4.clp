;/////////////////////// FASE 5 4: CONVOCAR EL CONCILIO LIBRE ///////////////////////
(defmodule P-5-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ir al concilio libre si ha sido convocado))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule mandatory-council
	(not (exists 
		(object (is-a OWNABLE) (name ?owned-card))
		(object (is-a CARD) (name ?owned-card) (state DRAW))
	))
	=>
	(make-instance (gen-name E-convoque-council) of E-convoque-council)
	(debug El Concilio de los Pueblos Libres ha sido convocado)
)


(defrule arrange-council#mp (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase P-5-4))
		(object (is-a PLAYER) (name ?p&:(eq ?p ?*player*)) (mp ?mp&:(<= 20 ?mp)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def convoque-council)
		(description (sym-cat "Convoque council"))
		(data (create$))
	))
)


(defrule arrange-council#empty-deck (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase P-5-4))
		(object (is-a PLAYER) (name ?p&:(eq ?p ?*player*)))
		(not (exists 
			(object (is-a OWNABLE) (name ?owned-card) (player ?p))
			(object (is-a CARD) (name ?owned-card) (state DRAW))
		))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def convoque-council)
		(description (sym-cat "Convoque council"))
		(data (create$))
	))
)