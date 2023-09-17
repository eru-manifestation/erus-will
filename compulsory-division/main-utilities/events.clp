; GENERADOR DE NOMBRES
(deffunction MAIN::gen-name (?class)
	; Función generadora de nombres referenciada en el make-instance
    ; hacerlo a través de esta función
	(bind ?instance-# 1)
	(do-for-instance ((?cualquiera ?class)) TRUE
		(bind ?instance-# (send ?cualquiera get-instance-#))
        (send ?cualquiera put-instance-# (+ 1 ?instance-#)))

	(sym-cat (lowcase ?class) ?instance-#)
)

; GENERADOR DE NUMERO DE INSTANCIAS (NO CUENTA REALMENTE EL NUMERO DE INSTANCIAS)
(deffunction MAIN::gen-# (?class)
	; Devuelve el primer numero de instancia libre
	(bind ?instance-# 1)
	(do-for-instance ((?cualquiera ?class)) TRUE
		(bind ?instance-# (send ?cualquiera get-instance-#))
    )
    (if (eq ?instance-# nil)
        then 1
        else (- ?instance-# 1)
    )
)



; DEFINICIÓN DE TEMPLATE EVENTO
(defclass MAIN::EVENT (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot event-definitor (type SYMBOL) (default ?NONE) (access initialize-only))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive))
	(multislot dont-use-data (default (create$)) (pattern-match non-reactive) (create-accessor ?NONE))
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
(defrule MAIN::event-garbage-collector (declare (auto-focus TRUE) (salience -100))
	; Destruye los eventos marcados como terminados
	?e <- (object (is-a EVENT) (type OUT))
	=>
	(send ?e delete)
)

; MECANISMOS DE OBTENCIÓN DE DATOS
(defmessage-handler EVENT get-data (?key)
	; (send ?e put-data <key>)
	(bind ?i (member$ ?key ?self:dont-use-data))
	(nth$ (+ 1 ?i) ?self:dont-use-data)
)

; MECANISMO DE MODIFICACIÓN DE DATOS DE EVENTO
(defmessage-handler EVENT put-data (?key ?value $?other)
	; (send ?e put-data <key-value>+)
	;	<key-value> := <key> <value>
	(bind ?i (member$ ?key ?self:dont-use-data))
	(if ?i
		then
		(bind ?self:dont-use-data (replace-member$ ?self:dont-use-data 
			(create$ ?key ?value)
			(create$ ?key (nth$ (+ 1 ?i) ?self:dont-use-data))))
		else
		(bind ?self:dont-use-data (insert$ ?self:dont-use-data 1 (create$ ?key ?value)))
	)
	(bind ?other-length (length$ ?other))
	(if (> ?other-length 0)
		then
		(send ?self put-data (nth$ 1 ?other) (nth$ 2 ?other) (subseq$ ?other 3 ?other-length))
	)
)

(defmessage-handler EVENT put-dont-use-data ($?data)
	(bind ?data-length (length$ ?data))
	(if (< 0 ?data-length)
		then (send ?self put-data (nth$ 1 ?data) (nth$ 2 ?data) (subseq$ ?data 3 ?data-length))
	)
)

; MECANISMO DE BORRADO DE DATOS DE EVENTO
(defmessage-handler EVENT delete-data (?key $?other)
	; (send ?e delete-data <key>+)
	(bind ?i (member$ ?key ?self:dont-use-data))
	(bind ?self:dont-use-data (delete-member$ ?self:dont-use-data
		(create$ ?key (nth$ (+ 1 ?i) ?self:dont-use-data))))
	(bind ?other-length (length$ ?other))
	(if (> ?other-length 0)
		then
		(send ?self delete-data (nth$ 1 ?other) (subseq$ ?other 2 ?other-length))
	)
)

; GENERADOR DE EVENTO
(deffunction MAIN::gen-event (?event-definitor $?event-data)
	; Función generadora de eventos, hacerlo a través de esta función
	; (gen-event <event-definitor> <event-data>*)
	(make-instance 
		(gen-name EVENT)
		of EVENT 
		(event-definitor ?event-definitor) 
		(dont-use-data ?event-data)
	)
)
