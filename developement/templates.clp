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

; JUMP BACKWARDS (copiar desde aqui)
(defrule jump-back-??? (declare (salience ?*jump-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage $?pre-stage ???ep-name ???arg1 ???arg2 ???ep-last-stage))
	=>
	(jump $?pre-stage)
)