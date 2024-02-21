;(set-dynamic-constraint-checking TRUE)
;(set-fact-duplication TRUE) ;TODO: eliminar el id del data-item, cuidado con los in
;(set-break <rule-name>)

(bind ?*print-message* TRUE)
(watch instances)
;(watch activations)
(watch rules)
(watch focus)
(watch message-handlers EVENT put-state after)
; (watch message-handlers EVENT hold)
; (watch message-handlers EVENT unhold)
;(watch message-handlers BASIC put-position after)
(run 64)
