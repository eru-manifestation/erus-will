;(set-dynamic-constraint-checking TRUE)
;(set-fact-duplication TRUE) ;TODO: eliminar el id del data-item, cuidado con los in
;(set-break <rule-name>)

;(set-break P-4::clock)

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

;TEST 1
; (run)
; (play-action player1 PASS)
; (play-action player1 [fellowship1] [grey-havens])
; (play-action player1 [fellowship1])

;TEST 2
(run)
(play-action player1 [shield-of-iron--bound-ash1] [aragorn-ii1])
;Both players updated
;
(play-action player1 PASS)
;Both players updated
;
(play-action player1 PASS)
;Both players updated
;
(play-action player1 [fellowship1])
;Both players updated
;
(play-action player1 [fellowship1])
;Both players updated
;
(play-action player1 [star--glass1] [star--glass1])
;        ^-- The command is rejected
;
(play-action player1 [star--glass1] [merry1])
;Both players updated
;
(play-action player1 [scroll-of-isildur1] [hand1])
;        ^-- The command is rejected
;
(play-action player1 [rangers-of-the-north1] [discard1])


; Player player1 commands: {[shield-of-iron--bound-ash1] [aragorn-ii1]}
; Both players updated

; Player player1 commands: {[elven-cloak1] PASS}
;         ^-- The command is rejected

; Player player1 commands: {PASS}
; Both players updated

; Player player1 commands: {[fellowship1] [fellowship1]}
;         ^-- The command is rejected

; Player player1 commands: {[fellowship1] [barrow--downs]}
; Both players updated

; Player player1 commands: {[fellowship1]}
; Both players updated

; Player player2 commands: {[draw2]}
; Both players updated

; Player player1 commands: {[fellowship1]}
; STAM_ERROR: Incorrect event state
; STAM_ERROR: Incorrect event state
; Both players updated