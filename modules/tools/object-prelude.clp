; GENERADOR DE NOMBRES
(deffunction TOOLS::gen-name (?class)
	; Función generadora de nombres referenciada en el make-instance
    ; hacerlo a través de esta función
	(bind ?instance-# 1)
	(do-for-instance ((?cualquiera ?class)) TRUE
		(bind ?instance-# (send ?cualquiera get-instance-#))
        (send ?cualquiera put-instance-# (+ 1 ?instance-#)))

	(sym-cat (lowcase ?class) ?instance-#)
)

; GENERADOR DE NUMERO DE INSTANCIAS (NO CUENTA REALMENTE EL NUMERO DE INSTANCIAS)
(deffunction TOOLS::gen-# (?class)
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