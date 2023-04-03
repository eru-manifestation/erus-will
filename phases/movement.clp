; Para cada compañía, crear el evento generador de fase
(defrule FELLOWSHIP-gen-move (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 3 1 0))
	
	; Crea el evento generador de fase para cada compañía
	; del personaje dueño del turno que no esté vacía
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
	; Encuentra la localización de la compañía
	(in (transitive FALSE) (under ?fell) (over ?loc))
	=>
	; EP indica event phase, ya que es el punto de entrada para esa fase
	(gen-event FELLOWSHIP-EP-move 
		fell ?fell
		from ?loc)
)


; Event handler para FELLOWSHIP-gen-move (es un salto)
(defrule handler-FELLOWSHIP-EP-move (declare (salience ?*jump-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 3 1 1))
	
	(object (is-a EVENT) (type IN) (event-definitor FELLOWSHIP-EP-move)
		(name ?e))
	=>
	(jump 3 1 1 move-fellowship (send ?e get-data fell) (send ?e get-data from) 0)
	(send ?e complete)
)
