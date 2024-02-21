;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////
(defmodule P-0-1-1 (import MAIN ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Genera evento enderezar carta no localizaciones))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule untap
    (player ?p)
	;Aprovecho que dos CE pueden referenciar conjuntamente al mismo elemento, afinando el cribado
	(object (is-a LOCATION) (name ?loc))
	(object (is-a CARD) (name ?c) (state TAPPED))
	(in (over ?loc) (under ?card))
	(object (is-a OWNABLE) (name ?c) (player ?p))
	(not (object (is-a LOCATION) (name ?c)))
	=>
	(E-modify ?c state UNTAPPED P011-untap)
	(message "En la fase Enderezamiento, enderezar todas las cartas no localizaciones del jugador")
)
