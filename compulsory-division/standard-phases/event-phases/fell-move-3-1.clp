;/////////////////// FELLWOSHIP MOVE 3 1: AMBOS PERSONAJES ROBAN UNA CARTA ////////////////////////
(defmodule fell-move-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INIT
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ambos personajes roban una carta, si deben robar)
(assert (both-draw-one#player) (both-draw-one#enemy)))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


; Calcula cuantas cartas debe robar cada jugador (no se roba si no se mueve)
(defrule both-draw-one#player
    ?unicity<-(both-draw-one#player)
    ?e<-(object (is-a EP-fell-move) (type ONGOING) (player-draw ?pd&:(< 0 ?pd)))
    =>
    (retract ?unicity)
    (make-instance (gen-name E-fell-move-player-draw) of E-fell-move-player-draw (fell-move ?e))
)

(defrule both-draw-one#enemy
    ?unicity<-(both-draw-one#enemy)
    ?e<-(object (is-a EP-fell-move) (type ONGOING) (enemy-draw ?pd&:(< 0 ?pd)))
    =>
    (retract ?unicity)    
    (make-instance (gen-name E-fell-move-enemy-draw) of E-fell-move-enemy-draw (fell-move ?e))
)