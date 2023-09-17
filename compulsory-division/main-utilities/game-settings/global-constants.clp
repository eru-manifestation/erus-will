(defglobal MAIN
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
    ;?*special-effects-salience* = 0

    ; Reglas que lanzan actions
    ?*action-population-salience* = -2

    ; Reglas que requieren la intervención del usuario (restringido para user-interaction)
    ?*action-selection-salience* = -4

    ; Intercepción de eventos tanto en la salida como la entrada
    ?*event-interception-salience* = -6

    ; Manejo y recolector de basura de eventos que no desencadenen saltos inmediatos
    ?*event-handler-salience* = -8

    ; Reglas de funcionamiento básico propias de las fases (EN DESUSO)
    ;?*phase-salience* = -10

    ; Exclusivo reglas de salto (hacia y desde fases eventuales y reglas
    ; que desencadenen saltos en general) EN DESUSO, YA QUE SON LLAMADOS COMO FUNCIONES
    ; EN EVENT HANDLERS
    ;?*jump-salience* = -12

    ; Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que
    ; se altere la fase en la que podrían ocurrir. Por tanto, cada regla se debe disparar
    ; durante la PRIMERA fase en la que se activen.
    ?*clock-salience* = -14
)