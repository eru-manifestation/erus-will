(deffunction MAIN::JSONformat (?data)
	(if (or (numberp ?data) (stringp ?data)) then
		(return ?data))
	(if (symbolp ?data) then
		(if (eq TRUE ?data) then
			(return true)
		else 
			(if (eq FALSE ?data) then
				(return false)
			)
		else
			(return (str-cat ?data))))
	(if (multifieldp ?data) then
		(bind ?res (JSONformat (nth$ 1 ?data)))
		(foreach ?d (rest$ ?data)
			(bind ?res (str-cat ?res " " (JSONformat ?d)))
		)
		(return ?res)
		)
	(if (instance-namep ?data) then
		(return (str-cat ?data)))
	(if (instance-addressp ?data) then
		(return (JSONformat (instance-name ?data))))
	(return "ERROR")
)


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

(defmessage-handler USER modify (?slotname ?value)
	; TODO HACER ANNOUNCE MODIFY AQUI
	(bind ?instance-name (instance-name ?self))
	(announce all { "operation" : "modify" ,
		"id" : (JSONformat ?instance-name) , 
		"slot" : (JSONformat ?slotname) ,
		"value" : (JSONformat ?value) }
	)
	(send ?instance-name (sym-cat put- ?slotname) ?value)
)

(defmessage-handler USER init after ()
	(bind ?class (class ?self))
	(bind ?superclasses (class-superclasses ?class inherit))
	(bind ?values (create$))
    (foreach ?slot (class-slots ?class inherit) 
		(bind ?values (insert$ ?values 1000 (create$ , (str-cat ?slot) : (JSONformat (dynamic-get ?slot)))))
	)
	(bind ?format (create$))
	(foreach ?unfclass ?superclasses
		(bind ?format (insert$ ?format 1000 (create$ , (str-cat (lowcase ?unfclass)))))
	)
	(bind ?classes
    	(create$ [ (implode$ (create$ (lowcase ?class))) ?format ] )
	)
    (announce all { "operation" : "create" ,
		; Nombre de la instancia
		"id" : (JSONformat (instance-name ?self)) ,
		; Clases de la instancia
		; La coma de cierre aparece en values
		"classes" : $?classes
		; Valores de la instancia
		?values }
	)
)

(defmessage-handler USER delete before ()
	(announce all { "operation" : "delete" , "id" : (JSONformat (instance-name ?self)) })
)