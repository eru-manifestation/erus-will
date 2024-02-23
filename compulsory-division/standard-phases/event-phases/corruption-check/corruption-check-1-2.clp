;/////////////////////// CORRUPTION CHECK 1 2: FIN EJECUCION DEL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-2 (import MAIN ?ALL) (import corruption-check-1-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule discard-character
	(target ?char)
	(dices ?dices)
	(object (is-a CHARACTER) (name ?char) (corruption ?corr))
	(test (or
		; Si el resultado es igual o 1 menor a los puntos de corrupcion del personaje, este se descarta (con lo que lleve excepto seguidores)
		(= ?dices ?corr) 
		(= (+ 1 ?dices) ?corr)
	))
	=>
	(E-modify ?char position (discardsymbol (send ?char get-player)) 
		DISCARD CHARACTER corruption-check-1-2::discard-character)
	(message "El resultado es " ?dices ", igual o 1 inferior a los puntos de corrupcion: " ?corr ". El personaje " ?char " se descarta.")
)


(defrule destroy-character
	(target ?char)
	(dices ?dices)
	(test 
		; Si el resultado es 2 menor a los puntos de corrupcion del personaje, este sale del juego (descarta lo que lleve excepto seguidores)
		(< (+ 1 ?dices) (send ?char get-corruption))
	)
	=>
	(E-modify ?char position (outofgamesymbol (send ?char get-player)) 
		DESTROY CHARACTER corruption-check-1-2::destroy-character)
)