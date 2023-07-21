
; REGLA DE FLUJO DE FASE DENTRO DE UN TURNO
(defrule MAIN::clock (declare (salience ?*clock-salience*))
	?p <- (phase (stage $?xs ?x))
	=>
	(bind ?jump-stage (stage-guide $?xs ?x))
	(if ?jump-stage then
		(modify ?p (stage ?jump-stage))
		else
		(modify ?p (stage $?xs (+ 1 ?x)))
	)
)


; ELIMINAR FASE PARA FINALIZAR PROGRAMA
(defrule MAIN::SALIDA-FORZADA-ELIMINAR (declare (salience ?*universal-rules-salience*))
	?f <- (phase (stage finalizar))
	=>
	(retract ?f)
	(halt)
)