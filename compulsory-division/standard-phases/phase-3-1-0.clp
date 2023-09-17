;//////////////////// Fase 3 1 0: INICIO MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Genera evento de movimiento))

; EVENT-PHASE: Para cada compañía, crear el evento generador de fase
(defrule gen-movement (declare (salience ?*phase-salience*))
	; Crea el evento generador de fase para cada compañía
	; del personaje dueño del turno que no esté vacía
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
	; Encuentra la localización de la compañía
	(in (transitive FALSE) (under ?fell) (over ?loc))
	=>
	; EP indica event phase, ya que es el punto de entrada para esa fase
	;(make-instance (gen-name MOVE-FELLOWSHIP-EP) of  MOVE-FELLOWSHIP-EP 
	;	(from ?from) (fell ?fell))
)