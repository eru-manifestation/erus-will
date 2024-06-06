(defglobal MAIN
    ; Reglas que NO REPRESENTAN reglas de juego, sino ayudas al programador. Deben tener saliencia máxima, ya que su incumplimiento puede significar la corrupción del estado del programa
    ; Ex: 
    ; - manejo de items de información
    ; - manejo de in
    ; - etc.
    ?*universal-rules* = 10

    ; Para efectos extra de cada carta, que desean ser interrumpidos por la ejecución de otras reglas del funcionamiento básico
    ;?*basic* = 0

    ; Reglas que lanzan actions
    ?*a-population* = 8

    ; Reglas que requieren la intervención del usuario (restringido para user-interaction)
    ?*a-selection* = 6

    ; Intercepción de eventos tanto en la salida como la entrada
    ?*E-intercept* = 4

    ; Manejo y recolector de basura de eventos que no desencadenen saltos inmediatos
    ?*E-next* = 2

    ; Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que se altere la fase en la que podrían ocurrir. Por tanto, cada regla se debe disparar durante la PRIMERA fase en la que se activen.
    ?*clock* = -14


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DEBUGGING
    ?*print-message* = FALSE
)