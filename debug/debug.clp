;(set-dynamic-constraint-checking TRUE)
;(set-fact-duplication TRUE) ;TODO: eliminar el id del data-item, cuidado con los in
;(set-break <rule-name>)

;(set-break fell-move-5::clock)

(bind ?*print-message* TRUE)
;(watch instances)
;(watch facts)
;(watch activations)
;(watch all)
(unwatch globals)
(watch globals MAIN::active-event)
(watch rules)
(watch focus)
; (watch message-handlers EVENT put-state after)
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
; (play-action player1 [elven-cloak1] [eomer1])
; ; Both players updated

; (play-action player1 [aragorn-ii1] [fellowship21])
; ; Both players updated

; (play-action player1 PASS)
; ; Both players updated

; (play-action player1 [fellowship1] [grey-havens])
; ; Both players updated

; (play-action player1 [aragorn-ii1] [aragorn-ii1])
; ;         ^-- The command is rejected

; (play-action player1 [fellowship21] [barrow--downs])
; ; Both players updated

; (play-action player1 [fellowship1])
; ; Both players updated

; (play-action player1 [draw1])
; ; Error: ENOENT: no such file or directory, stat 'C:\Users\Pablo\Documents\GitHub\erus-will\tw\icons\LesserSpiders.jpg'                                                                                                       rs.jpg'
; ; SE CONSIDERA QUE EL ERROR OCURRE EN LA INSTRUCCION ANTERIOR

; (play-action player2 [draw2])

; (play-action player1 PASS)
; (play-action player1 [fellowship1] [barrow--downs])
; (play-action player1 [fellowship1])
; (play-action player2 PASS)
; (play-action player1 [red-arrow1] [discard1])
; (play-action player2 [wood--elves1] [discard2])
; (play-action player1 [fellowship1])
; (play-action player1 [attackable-barrow--downs1] [aragorn-ii1])
; (play-action player1 [aragorn-ii1])
; (play-action player1 PASS)
