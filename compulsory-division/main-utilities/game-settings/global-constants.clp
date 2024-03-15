(defglobal MAIN
    ; Reglas que NO REPRESENTAN reglas de juego, sino ayudas al programador. Deben tener
    ; saliencia máxima, ya que su incumplimiento puede significar la corrupción
    ; del estado del programa
    ; Ex: 
    ; - manejo de items de información
    ; - manejo de in
    ; - caster
    ?*universal-rules* = 10

    ; Para efectos extra de cada carta, que desean ser interrumpidos por la ejecución
    ; de otras reglas del funcionamiento básico
    ; LO IDEAL ES NO UTILIZARLO, cuadrar estas reglas en la categoría de eventos 
    ; (de proponer cambios en el estado del programa), cambio de reloj (de ser cambios
    ; en la variable phase), acciones (de requerir la acción del usuario) ...
    ;?*special-effects* = 0

    ; Reglas que lanzan actions
    ?*a-population* = 8

    ; Reglas que requieren la intervención del usuario (restringido para user-interaction)
    ?*a-selection* = 6

    ; Intercepción de eventos tanto en la salida como la entrada
    ?*E-intercept* = 4

    ; Manejo y recolector de basura de eventos que no desencadenen saltos inmediatos
    ?*E-next* = 2

    ; Reglas de funcionamiento básico propias de las fases (EN DESUSO)
    ;?*phase* = -10

    ; Exclusivo reglas de salto (hacia y desde fases eventuales y reglas
    ; que desencadenen saltos en general) EN DESUSO, YA QUE SON LLAMADOS COMO FUNCIONES
    ; EN EVENT HANDLERS
    ;?*jump* = -12

    ; Exclusivo para el recolector de basura de eventos finalizados
    ?*garbage-collector* = -13

    ; Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que
    ; se altere la fase en la que podrían ocurrir. Por tanto, cada regla se debe disparar
    ; durante la PRIMERA fase en la que se activen.
    ?*clock* = -14


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DEBUGGING
    ; ?*message-traces* = FALSE
    ?*print-message* = FALSE
)