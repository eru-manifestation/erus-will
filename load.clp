(defglobal ?*route* = "C:\\Users\\Pablo\\Documents\\GitHub\\erus-will")
(set-strategy breadth)
;(set-dynamic-constraint-checking TRUE)
;(set-fact-duplication TRUE) ;TODO: eliminar el id del data-item, cuidado con los in
;(set-break <rule-name>)


;(class [instance-name])

; Cargo el modulo main
(deffunction load-utilities ()
    (chdir ?*route*)
    (load* "compulsory-division\\main-utilities\\innit.clp")
    (load* "compulsory-division\\main-utilities\\object-prelude.clp")
    (load* "compulsory-division\\main-utilities\\objects.clp")

    ;global-constants
    (load* "compulsory-division\\main-utilities\\game-settings\\global-constants.clp")

    ;game-settings
    (load* "compulsory-division\\main-utilities\\game-settings\\game-settings.clp")

    ;interactions and debug
    (load* "compulsory-division\\main-utilities\\user-interaction\\interaction.clp")

    ;locations
    (load* "compulsory-division\\main-utilities\\game-settings\\locations.clp")

    ;handGDEF
    (load* "compulsory-division\\main-utilities\\game-settings\\cards-def.clp")

    ;in manager
    (load* "compulsory-division\\main-utilities\\in.clp")

    ;fellowship manager
    (load* "compulsory-division\\main-utilities\\fellowships.clp")


    ;events
    (load* "compulsory-division\\main-utilities\\events.clp")
    
    ;clock manager
    (load* "compulsory-division\\main-utilities\\clock.clp")

    ;standard-events
    (load* "compulsory-division\\main-utilities\\standard-event-phases.clp")
    (load* "compulsory-division\\main-utilities\\standard-events.clp")

    ;action manager
    (load* "compulsory-division\\main-utilities\\user-interaction\\actions.clp")

    ;data items
    (load* "compulsory-division\\main-utilities\\data-items.clp")
)

(deffunction load-standard()
    (chdir ?*route*)
    (load* "compulsory-division\\standard-phases\\start-game-0.clp")
    (load* "compulsory-division\\standard-phases\\start-game-1.clp")

    (load* "compulsory-division\\standard-phases\\phase-0-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-0-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-2-0.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-3-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-3-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-4.clp")
    (load* "compulsory-division\\standard-phases\\phase-5-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-5-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-5-3.clp")
    (load* "compulsory-division\\standard-phases\\phase-5-4.clp")
    (load* "compulsory-division\\standard-phases\\phase-5-5.clp")


    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-1-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-1-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-2.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\loc-organize-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\loc-organize-2.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-3-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-3-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-3-3.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-4-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-4-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-4-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-5-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-5-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-6.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-7.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\both-players-draw-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\both-players-draw-1.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\loc-phase-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\loc-phase-2-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\loc-phase-3-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\loc-phase-4.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\faction-play-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\faction-play-2-1.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\free-council-1-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\free-council-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\free-council-2-1.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\attack-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-2-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-2-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-2-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-2-3.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-3.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-4.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\attack-5.clp")
    
    (load* "compulsory-division\\standard-phases\\event-phases\\strike-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\strike-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\strike-3-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\strike-3-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\strike-4.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\resistance-check-0.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\resistance-check-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\resistance-check-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\resistance-check-3.clp")

    
)

; Cargo todas los archivos
(deffunction load-all ()
    (chdir ?*route*)
    (load-utilities)
    (load-standard)
    
)

(load-all)
;(watch rules)
;(watch instances E-char-play E-item-play-only-minor)
;(run 40)
;(run 3)
;(send [wolves1] put-state HAND) ;Testar el ataque
(run)