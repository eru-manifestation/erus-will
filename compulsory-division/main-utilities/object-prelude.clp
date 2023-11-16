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