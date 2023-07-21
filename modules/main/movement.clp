
;//////////////////// Fase 3 0: INICIO FASE MOVIMIENTO ///////////////////////

;//////////////////// Fase 3 1 0: INICIO MOVER COMPAÑÍAS ///////////////////////

; EVENT-PHASE: Para cada compañía, crear el evento generador de fase
(defrule MAIN::FELLOWSHIP-gen-move (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 3 1 0))
	
	; Crea el evento generador de fase para cada compañía
	; del personaje dueño del turno que no esté vacía
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
	; Encuentra la localización de la compañía
	(in (transitive FALSE) (under ?fell) (over ?loc))
	=>
	; EP indica event phase, ya que es el punto de entrada para esa fase
	(make-instance (gen-name MOVE-FELLOWSHIP-EP) of  MOVE-FELLOWSHIP-EP 
		(from ?from) (fell ?fell))
)


;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////

; EVENT HANDLER: FELLOWSHIP-gen-move (es un salto)
(defrule MAIN::handler-FELLOWSHIP-EP-move (declare (salience ?*jump-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 3 1 1))
	
	(object (is-a EVENT) (type IN) (event-definitor FELLOWSHIP-EP-move)
		(name ?e))
	=>
	(jump 3 1 1 move-fellowship (send ?e get-data fell) (send ?e get-data from) 0)
	(send ?e complete)
)


;//////////////////// Fase 3 1 2: FIN MOVER COMPAÑÍAS ///////////////////////

;//////////////////// Fase 3 2: FIN FASE COMPAÑÍAS ///////////////////////





