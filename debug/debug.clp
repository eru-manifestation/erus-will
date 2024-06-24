; (set-break loc-phase-2-1::clock)
; (set-break faction-play-3::influence-check)

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
; (watch message-handlers BASIC put-position after)
; (run 145)

;TEST 1
; (run)
; (play-action player1 PASS)
; (play-action player1 [fellowship1] [grey-havens])
; (play-action player1 [fellowship1])

;TEST 2
; (run)
; (play-action player1 PASS)
; (play-action player1 [fellowship1] [barrow--downs])
; (play-action player1 [fellowship1])
; (play-action player2 PASS)
; (play-action player1 [gandalf1] [discard1])
; (play-action player2 [saruman1] [discard2])
; (play-action player1 [fellowship1])
; (play-action player1 [attackable-barrow--downs] [kili1])
; ;(play-action player1 [kili1])
; ;(play-action player1 [kili1])
; (E-play [gandalf1] [fellowship1] because)

;TEST 3
(unwatch all)
(run)
(play-action player1 [PASS])

(play-action player1 [fellowship1] [goblin--gate])

(play-action player1 [fellowship1])

(play-action player2 [PASS])

(play-action player2 [wolves2] [fellowship1])

(play-action player1 [wolves2] [boromir-ii1])

(play-action player1 [wolves2] [aragorn-ii1])

(play-action player1 [wolves2] [merry1])

(play-action player1 [merry1])

(play-action player1 [PASS])

(play-action player1 [boromir-ii1])

(play-action player1 [PASS])

(play-action player1 [aragorn-ii1])

(play-action player1 [aragorn-ii1])

;(play-action player2 [wolves3] [fellowship1])
