(defclass BASIC (is-a USER)
    (role abstract)
    (slot instance-# (type INTEGER) (default 0) (storage shared))
)

; GENERADOR DE NOMBRES
(deffunction gen (?class)
	; Función generadora de eventos, hacerlo a través de esta función
	; (gen-event <event-definitor> <event-data>*)
	(bind ?new-instance-# 1)
	(bind ?instance-# 
		(do-for-instance ((?cualquiera ?class)) TRUE
			(send ?cualquiera get-instance-#))
	)
	(if ?instance-# then (bind ?new-instance-# (+ 1 ?instance-#)))
	(sym-cat ?class ?new-instance-#)
)


(defmessage-handler BASIC get-name ()
    (println "Funciona mu bien")
    (bind ?self:instance-# (+ 1 ?self:instance-#))
    (sym-cat class-name instance-#)
)

(defclass BASIC2 (is-a BASIC)
)