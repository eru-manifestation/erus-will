;/////////////////// FACTION PLAY 1 1: EJECUCION LANZAR DADOS CHEQUEO DE INFLUENCIA ////////////////////////
(defmodule faction-play-1-1 (import MAIN ?ALL) (export ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule dice-roll
	=>
	(assert (data (phase faction-play) (data dices (+ (random 1 6) (random 1 6)))))
)


(defrule race-modifier
    (data (phase faction-play) (data faction ?faction))
	(data (phase faction-play) (data char ?char))
	?f <- (data (phase faction-play) (data dices ?n))
    (object (is-a CHARACTER) (name ?char) (race ?race))
    (object (is-a FACTION) (name ?faction) (influence-modifiers $? ?race ?value $?))
    =>
	(retract ?f)
	(assert (data (phase faction-play) (data dices (+ ?n ?value))))
    (message "Se modifica el resultado de la tirada de dados con el modificador por raza")
)