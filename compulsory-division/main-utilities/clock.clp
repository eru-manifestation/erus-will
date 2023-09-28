(defglobal MAIN ?*phase-list* = (create$ 

P-0-1-1
P-0-2-1
P-1-1-1
P-2-1-1
P-2-2-1
P-2-3-1
;P-3-1-0
P-3-1-1
FALSE
corruption-check-1-1-1
corruption-check-1-2
corruption-check-2
FALSE

)
	?*tics* = 0
	?*jumps* = 0
)

(deftemplate only-actions (slot phase (type SYMBOL) (default ?NONE)))

(deffunction MAIN::jump (?jump-stage)
    (focus ?jump-stage)
	(bind ?*jumps* (+ 1 ?*jumps*))
	(do-for-fact ((?only-actions only-actions)) TRUE (retract ?only-actions))
	(assert (only-actions (phase ?jump-stage)))
)

; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	(jump P-0-1-1) 
	(assert (post-draw))
	(assert (infinite))
)


; RECUPERA EL FOCO ACTUAL Y LO COMPARA EN LA LISTA PARA DEVOLVER EL FOCO SIGUIENTE
(deffunction MAIN::stage-guide (?stage)
	(bind ?i (member$ ?stage $?*phase-list*))
	(nth$ (+ 1 ?i) $?*phase-list*)
)

; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic (?stage)
	(bind ?jump-stage (stage-guide ?stage))
	(printout t FOCUS------------------------------------(get-focus-stack) crlf)
	(if ?jump-stage then
		(pop-focus)
		(focus ?jump-stage)
		(bind ?*tics* (+ 1 ?*tics*))

		(do-for-fact ((?only-actions only-actions)) TRUE (retract ?only-actions))
		(assert (only-actions (phase ?jump-stage)))
		else
		(do-for-fact ((?only-actions only-actions)) TRUE (retract ?only-actions))
		(if (eq (nth$ 2 (get-focus-stack)) MAIN) then
			(if (< (length$ (get-focus-stack)) 3) then (debug Fin de la partida) else (assert (only-actions (phase (nth$ 3 (get-focus-stack))))))
		else
		(assert (only-actions (phase (nth$ 2 (get-focus-stack)))))
		)
	)
)