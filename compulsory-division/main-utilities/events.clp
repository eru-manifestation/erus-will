; DEFINICIÓN DE TEMPLATE EVENTO
(defclass MAIN::EVENT (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive))
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT HANDLER
(defmessage-handler EVENT complete()
	; Lo marca como terminado
	(send ?self put-type OUT)
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENTO
(defmessage-handler EVENT defuse ()
	; Desactiva el evento y lo marca como terminado
	(send ?self put-defused TRUE)
	(send ?self put-type OUT)
)

; RECOLECTOR DE BASURA
(defrule MAIN::event-garbage-collector (declare (auto-focus TRUE) 
		(salience ?*garbage-collector-salience*))
	; Destruye los eventos marcados como terminados
	?e <- (object (is-a EVENT) (type OUT))
	=>
	(send ?e delete)
)
