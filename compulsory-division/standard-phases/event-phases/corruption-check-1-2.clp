;/////////////////////// CORRUPTION CHECK 1 2: FIN EJECUCION DEL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INIT
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Fin ejecucion chequeo corrupcion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule discard-character
	(object (is-a EP-corruption-check) (type ONGOING) (character ?char) (dices ?dices))
	(test (and
		; Si el resultado es igual o 1 menor a los puntos de corrupcion del personaje, este se descarta (con lo que lleve excepto seguidores)
		(= ?dices (send ?char get-corruption)) 
		(= (+ 1 ?dices) (send ?char get-corruption))
	))
	=>
	(make-instance (gen-name E-char-discard) of E-char-discard (character ?char))
)


(defrule destroy-character
	(object (is-a EP-corruption-check) (type ONGOING) (character ?char) (dices ?dices))
	(test 
		; Si el resultado es 2 menor a los puntos de corrupcion del personaje, este sale del juego (descarta lo que lleve excepto seguidores)
		(< (+ 1 ?dices) (send ?char get-corruption))
	)
	=>
	(make-instance (gen-name E-char-destroy) of E-char-destroy (character ?char))
)