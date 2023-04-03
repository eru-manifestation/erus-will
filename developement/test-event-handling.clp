; Event handler genérico (copiar desde aquí)
(defrule handler-test (declare (salience ?*event-handling-salience*))
	; Estamos en la fase correcta
	
	(object (is-a EVENT) (type IN) (event-definitor TEST)
		(name ?e&:(not (send ?e get-defused))))
    
	=>
    ; Acciones del evento
    (println (send ?e print))
	(send ?e complete)
)