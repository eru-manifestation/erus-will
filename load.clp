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
    (load* "compulsory-division\\main-utilities\\game-settings\\handGDEF.clp")

    ;in manager
    (load* "compulsory-division\\main-utilities\\in.clp")

    ;data items
    (load* "compulsory-division\\main-utilities\\data-items.clp")

    ;fellowship manager
    (load* "compulsory-division\\main-utilities\\fellowships.clp")

    ;clock manager
    (load* "compulsory-division\\main-utilities\\clock.clp")

    ;events
    (load* "compulsory-division\\main-utilities\\events.clp")
    (load* "compulsory-division\\main-utilities\\standard-event-phases.clp")
    (load* "compulsory-division\\main-utilities\\standard-events.clp")

    ;action manager
    (load* "compulsory-division\\main-utilities\\user-interaction\\actions.clp")

    ;handG
    (load* "compulsory-division\\main-utilities\\game-settings\\handG.clp")
)

(deffunction load-standard()
    (chdir ?*route*)
    (load* "compulsory-division\\standard-phases\\phase-0-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-0-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-2-0.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-3-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-3-1-1.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-1-1-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-1-2.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\corruption-check-2.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\loc-organize-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\loc-organize-2.clp")

    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-1.clp")
    (load* "compulsory-division\\standard-phases\\event-phases\\fell-move-2.clp")
)

(deffunction load-handG()
    (chdir ?*route*)
)

; Cargo todas los archivos
(deffunction load-all ()
    (chdir ?*route*)
    (load-utilities)
    (load-standard)
    (load-handG)
    
)

(load-all)
(init-locations)
(init-handG)
;(watch rules)
;(run 40)
(run)


