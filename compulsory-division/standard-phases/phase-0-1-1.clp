;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////
(defmodule P-0-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Genera evento enderezar carta no localizaciones))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


; EVENTO: En la fase Enderezamiento, enderezar todas las cartas no localizaciones del jugador
(defrule untap
	;Aprovecho que dos CE pueden referenciar conjuntamente al mismo elemento, afinando el cribado
	(object (is-a CARD) (name ?c) (state TAPPED))
	(object (is-a OWNABLE) (name ?c) (player ?p&:(eq ?p ?*player*)))
	(not (object (is-a LOCATION) (name ?c)))
	=>
	(make-instance (gen-name E-card-untap) of E-card-untap (card ?c))
)
