; DEFINICIÓN DE TEMPLATE EVENTO
(defclass MAIN::EVENT (is-a NUMERABLE)
    (slot instance-# (source composite))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive))
)


; DEFINICION DEL EVENTO DE FASE EVENTUAL
(defclass MAIN::EVENT-PHASE (is-a NUMERABLE)
    (slot instance-# (source composite))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT ONGOING))
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive))
	
	(slot ep-name (type SYMBOL) (default ?NONE))
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT HANDLER
(defmessage-handler EVENT complete()
	; Lo marca como terminado
	(bind ?self:type OUT)
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENTO
(defmessage-handler EVENT defuse ()
	; Desactiva el evento y lo marca como terminado
	(bind ?self:defused TRUE)
	(bind ?self:type OUT)
)

; RECOLECTOR DE BASURA
(defrule MAIN::event-garbage-collector (declare (auto-focus TRUE) 
		(salience ?*garbage-collector-salience*))
	; Destruye los eventos marcados como terminados
	?e <- (object (is-a EVENT | EVENT-PHASE) (type OUT))
	=>
	(send ?e delete)
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT-PHASE HANDLER
(defmessage-handler EVENT-PHASE complete()
	(bind ?self:type OUT)
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENT-PHASE (o se pare)
(defmessage-handler EVENT-PHASE defuse ()
	(bind ?self:defused TRUE)
	(bind ?self:type OUT)
	; TODO: que ocurre cuando defuseas un EVENT-PHASE?
)