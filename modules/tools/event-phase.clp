
; Tanto si se desactiva como si se completa, debe activar el próximo indicador de 
; fase eventual (de haberlo)
(deffunction TOOLS::call-next-EP (?event)
    ; Verificar que el evento no está defuseado ya (not (type OUT))
    ; Debería poder desactivarse un módulo en espera? Creo que sí: antes de activar
    ; al próximo índice de fase eventual debo saber si el que trato es el ÚNICO activo
    (bind ?no-next-EP TRUE)
    (do-for-instance ((?candidate-ep EVENT-PHASE)) 
        (and 
            (eq ?candidate-ep:type WAITING)
            (not (any-instancep ((?other-ep EVENT-PHASE)) 
                (and (eq ?other-ep:type WAITING) (< ?candidate-ep:priority ?other-ep:priority)))))
        
        ; Dado el indicador de fase eventual con mayor prioridad de entre todos los que están
        ; esperando, lo activo y enfoco su módulo
        (send ?candidate-ep put-type IN)
        (focus ?candidate-ep:module)
        (bind ?no-next-EP FALSE)
    )
    ; Si no quedan índices de fases eventuales que atender, retornar al módulo principal
    (if ?no-next-EP
        then
        (focus MAIN)
    )
)

; Pone a la espera automáticamente al indicador de fase eventual (de haberlo) que
; esté activo y pone el foco sobre sí mismo
(defmessage-handler EVENT-PHASE init before ()
    (do-for-instance ((?ep EVENT-PHASE)) (eq ?ep:type IN)
        (send ?ep put-type WAITING)
    )
    (send ?self put-event-definitor EP)
    (bind ?self:priority (gen-# EVENT-PHASE))
    (focus ?self:module)
)

(defmessage-handler EVENT-PHASE complete after ()
    (call-next-EP ?self)
)

(defmessage-handler EVENT-PHASE defuse after ()
    (call-next-EP ?self)
)
