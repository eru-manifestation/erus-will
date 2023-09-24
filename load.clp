(defglobal ?*route* = "C:\\Users\\Pablo\\Documents\\GitHub\\erus-will")

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

    ;in manager
    (load* "compulsory-division\\main-utilities\\in.clp")

    ;fellowship manager
    (load* "compulsory-division\\main-utilities\\fellowships.clp")

    ;clock manager
    (load* "compulsory-division\\main-utilities\\clock.clp")

    ;events
    (load* "compulsory-division\\main-utilities\\events.clp")
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
    (load* "compulsory-division\\standard-phases\\phase-2-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-3-1.clp")
    ;(load* "compulsory-division\\standard-phases\\phase-3-1-0.clp")
    (load* "compulsory-division\\standard-phases\\phase-3-1-1.clp")
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



