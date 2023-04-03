; Event handler genérico (copiar desde aquí)
(defrule handler-??? (declare (salience ?*event-handling-salience*))
	; Estamos en la fase correcta
	(phase (stage ???))
	
	(object (is-a EVENT) (type IN) (event-definitor ???)
		(name ?e))
    
    ; Otras condiciones
    ???
	=>
    ; Acciones del evento
	???
	(send ?e complete)
)


; Caster genérico (copiar desde aquí)
(defrule cast-??? (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage ???))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ??? ???)
)

; JUMP BACKWARDS (copiar desde aqui) (DEPRECATED)
(defrule jump-back-??? (declare (salience ?*jump-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $?pre-stage ???ep-name ???arg1 ???arg2 ???ep-last-stage))
	=>
	(jump $?pre-stage)
)

; /////////////////////////////// MODULE ////////////////////////////////////////

; JUMP BACKWARDS (MODULE) (copiar desde aqui)
(defrule ???::module-jump-back
	; COMPORTAMIENTO INADECUADO SI ALGUNA CONSTANTE DE SALIENCIA ESTÁ FUERA DE (-50,50)
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*clock-salience*)))
	(object (is-a EVENT-PHASE) (event-definitor ???) (type IN)
		(priority ?p&:(eq ?p (gen-# EVENT-PHASE))) (name ?e) (stage ???))
	=>
	(send ?e complete)
	(pop-focus)
)

; REGLA ESTANDAR PARA MODULOS (MODULE) (copiar desde aqui)
(defrule ???::module-??? 
	; COMPORTAMIENTO INADECUADO SI ALGUNA CONSTANTE DE SALIENCIA ESTÁ FUERA DE (-50,50)
	(declare (salience (+ (* 100 (gen-# EVENT-PHASE)) ?*phase-salience*)))
	(object (is-a EVENT-PHASE) (event-definitor ???) (type IN) (player ?p)
		(priority ?p&:(eq ?p (gen-# EVENT-PHASE))) (name ?e) (stage ???))
	
	???
	=>
	???
)