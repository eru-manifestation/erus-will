; FUNCION QUE DEFINE DÓNDE ESTÁ PENSADO QUE EXISTA EL EVENTO, LLAMADA AL SER SER COMPLETADO
;  O DESACTIVADO 
(deffunction get-target-phase ()
	(bind ?phase (nth$ 2 (get-focus-stack)))
	(bind ?length (str-length ?phase))
	(bind ?index nil)
	(loop-for-count (?i 1 ?length) do
		(if (not (numberp (string-to-field (sub-string (- ?length ?i) ?length ?phase)))) then 
			(bind ?index ?i)
			(break)
		)
	)
	(string-to-field (sub-string 1 (- ?length ?index) ?phase))
)



; DEFINICIÓN DE TEMPLATE EVENTO
(defclass MAIN::EVENT (is-a NUMERABLE)
    (slot instance-# (source composite))
	(slot target-phase (type SYMBOL))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive) (visibility public))
)


; DEFINICION DEL EVENTO DE FASE EVENTUAL
(defclass MAIN::EVENT-PHASE (is-a EVENT)
    (slot instance-# (source composite))
	(slot target-phase (type SYMBOL))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT ONGOING))
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT HANDLER
(defmessage-handler EVENT complete()
	; Lo marca como terminado
	(bind ?self:type OUT)
	(bind ?self:target-phase (get-target-phase))
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENTO
(defmessage-handler EVENT defuse ()
	; Desactiva el evento y lo marca como terminado
	(bind ?self:defused TRUE)
	(bind ?self:type OUT)
	(bind ?self:target-phase (get-target-phase))
)


; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT-PHASE HANDLER
(defmessage-handler EVENT-PHASE complete()
	(bind ?self:type OUT)
	(bind ?self:target-phase (get-target-phase))
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENT-PHASE (o se pare)
(defmessage-handler EVENT-PHASE defuse ()
	(bind ?self:defused TRUE)
	(bind ?self:type OUT)
	(bind ?self:target-phase (get-target-phase))
	; TODO: que ocurre cuando defuseas un EVENT-PHASE?
)