(defmodule TOOLS (export ?ALL))

(defglobal TOOLS
	; COMPORTAMIENTO INADECUADO SI ALGUNA CONSTANTE DE SALIENCIA ESTÁ FUERA DE (-50,50)

    
    ; Reglas que NO REPRESENTAN reglas de juego, sino ayudas al programador. Deben tener
    ; saliencia máxima, ya que su incumplimiento puede significar la corrupción
    ; del estado del programa
    ; Ex: 
    ; - manejo de items de información
    ; - manejo de in
    ; - caster
    ?*universal-rules-salience* = 10

    ; Para efectos extra de cada carta, que desean ser interrumpidos por la ejecución
    ; de otras reglas del funcionamiento básico
    ; LO IDEAL ES NO UTILIZARLO, cuadrar estas reglas en la categoría de eventos 
    ; (de proponer cambios en el estado del programa), cambio de reloj (de ser cambios
    ; en la variable phase), acciones (de requerir la acción del usuario) ...
    ?*special-effects-salience* = 0

    ; Reglas que lanzan actions
    ?*action-population-salience* = -2

    ; Reglas que requieren la intervención del usuario
    ?*action-selection-salience* = -4

    ; Intercepción de eventos tanto en la salida como la entrada
    ?*event-interception-salience* = -6

    ; Manejo y recolector de basura de eventos que no desencadenen saltos inmediatos
    ?*event-handler-salience* = -8

    ; Reglas de funcionamiento básico propias de las fases
    ?*phase-salience* = -10

    ; Exclusivo reglas de salto (hacia y desde fases eventuales y reglas
    ; que desencadenen saltos en general)
    ?*jump-salience* = -12

    ; Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que
    ; se altere la fase en la que podrían ocurrir. Por tanto, cada regla se debe disparar
    ; durante la PRIMERA fase en la que se activen.
    ?*clock-salience* = -14
)


; GENERADOR DE NOMBRES
(deffunction TOOLS::gen-name (?class)
	; Función generadora de nombres referenciada en el make-instance
    ; hacerlo a través de esta función. Incrementa instance-#
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


;/////////////////////////////////////////////////////////////////////////////////







(defmodule M1 (import TOOLS ?ALL))

(defrule M1::r1 (declare (salience ?*phase-salience*))
    (object (is-a EVENT-PHASE) (type IN) (name ?e) (priority ?n) (stage start))
    => 
    (println "SE INICIA "?n)
    (send ?e put-stage (create$ finish))
)

(defrule M1::r2 (declare (salience ?*phase-salience*))
    (object (is-a EVENT-PHASE) (type IN) (name ?e) (priority ?n) (stage finish))
    => 
    (println "SE TERMINA "?n)
    (send ?e complete)
)

(focus TOOLS)
(make-instance (gen-name EVENT-PHASE) of EVENT-PHASE (module M1) (player [player1]))
(make-instance (gen-name EVENT-PHASE) of EVENT-PHASE (module M1) (player [player1]))
(make-instance (gen-name EVENT-PHASE) of EVENT-PHASE (module M1) (player [player1]))
(watch instances)
(watch rules)
(watch focus)