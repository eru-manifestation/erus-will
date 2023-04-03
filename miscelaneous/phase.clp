; DEFINICIÓN DEL TEMPLATE DE FASE
(deftemplate phase
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(multislot stage (default ?NONE))
)

(deffunction start-turn (?player)
	; No sobreescribe la fase, crea una nueva
	(assert (phase (player ?player) (stage (create$ start))))
)

; FUNCION ESQUEMA DE FASES
(deffunction stage-guide ($?stage)
	(switch ?stage
		(case (create$ start) then (create$ 0 0))
		(case (create$ 0 0) then (create$ 0 1 0))
		(case (create$ 0 1 2) then (create$ 0 2 0))
		(case (create$ 0 2 2) then (create$ 0 3))
		(case (create$ 0 3) then (create$ 1 0))
		(case (create$ 1 0) then (create$ 1 1 0))
		(case (create$ 1 1 2) then (create$ 1 2))
		(case (create$ 1 2) then (create$ 2 0))
		(case (create$ 2 0) then (create$ 2 1 0))
		(case (create$ 2 1 2) then (create$ 2 2 0))
		(case (create$ 2 2 2) then (create$ 2 3 0))
		(case (create$ 2 3 2) then (create$ 2 4))
		(case (create$ 2 4) then (create$ 3 0))
		(case (create$ 3 0) then (create$ 3 1 0))
		(case (create$ 3 1 2) then (create$ 3 2))
		(case (create$ 3 2) then finalizar)
		(default FALSE))
)

; REGLA DE FLUJO DE FASE DENTRO DE UN TURNO
(defrule clock (declare (salience ?*clock-salience*))
	?p <- (phase (stage $?xs ?x))
	=>
	(bind ?next-stage (stage-guide $?xs ?x))
	(if ?next-stage then
		(modify ?p (stage ?next-stage))
		else
		(modify ?p (stage $?xs (+ 1 ?x)))
	)
)

; FUNCION DE SALTO DE FASE, USADA POR LAS ACCIONES Y EVENTOS
(deffunction jump ($?jump-stage)
	(do-for-fact ((?phase phase)) TRUE (modify ?phase (stage $?jump-stage)))
) 

; ELIMINAR FASE PARA FINALIZAR PROGRAMA
(defrule SALIDA-FORZADA-ELIMINAR (declare (salience ?*universal-rules-salience*))
	?f <- (phase (stage finalizar))
	=>
	(retract ?f)
	(halt)
)