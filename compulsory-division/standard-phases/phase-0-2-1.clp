;/////////////////// FASE 0 2 1: EJECUCION CURAR PERSONAJES EN REFUGIOS ////////////////////////
(defmodule P-0-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Cura personajes en refugios))

; EVENTO: Curar personajes y aliados heridos en refugios
(defrule heal
	(object (is-a CHARACTER | ALLY) (name ?c) (state WOUNDED))
	(object (is-a LOCATION) (name ?loc) (is-haven TRUE))
	(in (over ?loc) (under ?c))
	=>
	(make-instance (gen-name E-cure) of E-cure (card ?c))
)