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

)
	?*tics* = 0
	?*jumps* = 0
)

(deffunction MAIN::jump (?jump-stage)
    (focus ?jump-stage)
	(bind ?*jumps* (+ 1 ?*jumps*))
)

; REGLA DE INICIO DE JUEGO
(defrule MAIN::start => 
	(jump P-0-1-1)
)


; RECUPERA EL FOCO ACTUAL Y LO COMPARA EN LA LISTA PARA DEVOLVER EL FOCO SIGUIENTE
(deffunction MAIN::stage-guide (?stage)
	(bind ?i (member$ ?stage $?*phase-list*))
	(nth$ (+ 1 ?i) $?*phase-list*)
)

; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic (?stage)
	(bind ?jump-stage (stage-guide ?stage))
	(if ?jump-stage then
		(pop-focus)
		(focus ?jump-stage)
		(bind ?*tics* (+ 1 ?*tics*))
	)
)