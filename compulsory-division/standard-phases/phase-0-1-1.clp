;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////
(defmodule P-0-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) =>
(announce (sym-cat DEV - (get-focus)) Genera evento enderezar carta no localizaciones))

; EVENTO: En la fase Enderezamiento, enderezar todas las cartas no localizaciones
(defrule enderezar
	(object (is-a CARD) (name ?c) (state TAPPED) (player ?p))
	;(test (not (send ?c is-a LOCATION)))
	(not (object (is-a LOCATION) (name ?c)))
	=>
	(make-instance (gen-name E-card-untap) of E-card-untap (card ?c))
)
