;/////////////////// FELLWOSHIP MOVE 5 0: EJECUCION LLEGAR AL LUGAR ////////////////////////
(defmodule fell-move-5-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug The player gets to the location, discarding the previous if needed))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Saca del juego una localización si no es refugio y está girada
(defrule loc-destroy (declare (salience ?*action-population-salience*))
	(object (is-a EP-fell-move) (type ONGOING) 
		(from ?from&:(and (neq HAVEN (send ?from get-place)) (eq TAPPED (send ?from get-state)))))
	=>
	(make-instance (gen-name E-loc-destroy) of E-loc-destroy (loc ?from))
)


; Devuelve el refugio a posicion inicial
(defrule haven-untap (declare (salience ?*action-population-salience*))
	(object (is-a EP-fell-move) (type ONGOING) 
		(from ?from&:(and (eq HAVEN (send ?from get-place)) (eq TAPPED (send ?from get-state)))))
	=>
	(make-instance (gen-name E-card-untap) of E-card-untap (card ?from))
)