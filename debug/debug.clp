;(set-dynamic-constraint-checking TRUE)
;(set-fact-duplication TRUE) ;TODO: eliminar el id del data-item, cuidado con los in
;(set-break <rule-name>)

(set-break phase-4::clock)

(bind ?*print-message* TRUE)
;(watch instances)
(watch facts)
;(watch activations)
(watch rules)
(watch focus)
(watch message-handlers EVENT put-state after)
(watch message-handlers EVENT hold)
(watch message-handlers EVENT unhold)
; (watch message-handlers EVENT hold)
; (watch message-handlers EVENT unhold)
;(watch message-handlers BASIC put-position after)
; (run 145)
(run)
(play-action player1 PASS)
(play-action player1 [fellowship1] [grey-havens])
(play-action player1 [fellowship1])

;TODO: testear

;;Player player1 commands: {[shield-of-iron--bound-ash1] [aragorn-ii1]}
;Both players updated
;
;Player player1 commands: {PASS}
;Both players updated
;
;Player player1 commands: {PASS}
;Both players updated
;
;Player player1 commands: {[fellowship1]}
;Both players updated
;
;Player player1 commands: {[fellowship1]}
;Both players updated
;
;Player player1 commands: {[star--glass1] [star--glass1]}
;        ^-- The command is rejected
;
;Player player1 commands: {[star--glass1] [merry1]}
;Both players updated
;
;Player player1 commands: {[scroll-of-isildur1] [hand1]}
;        ^-- The command is rejected
;
;Player player1 commands: {[rangers-of-the-north1] [discard1]}