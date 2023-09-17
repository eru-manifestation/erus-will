(defglobal ?*route* = "C:\\Users\\Pablo\\Documents\\GitHub\\erus-will")

; Cargo el modulo main
(deffunction load-utilities ()
    (chdir ?*route*)
    (load* "compulsory-division\\main-utilities\\innit.clp")
    (load* "compulsory-division\\main-utilities\\object-prelude.clp")
    (load* "compulsory-division\\main-utilities\\objects.clp")

    ;game-settings
    (load* "compulsory-division\\main-utilities\\game-settings\\game-settings.clp")
    (load* "compulsory-division\\main-utilities\\game-settings\\global-constants.clp")

    ;events
    (load* "compulsory-division\\main-utilities\\events.clp")

    (load* "compulsory-division\\main-utilities\\in.clp")
    (load* "compulsory-division\\main-utilities\\clock.clp")

    ;user-interaction
    (load* "compulsory-division\\main-utilities\\user-interaction\\interaction.clp")
    (load* "compulsory-division\\main-utilities\\user-interaction\\actions.clp")
)

(deffunction load-standard()
    (chdir ?*route*)
    (load* "compulsory-division\\standard-phases\\phase-0-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-0-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-1-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-1-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-2-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-2-3-1.clp")
    (load* "compulsory-division\\standard-phases\\phase-3-1-0.clp")
    (load* "compulsory-division\\standard-phases\\phase-3-1-1.clp")
)

; Cargo todas los archivos
(deffunction load-all ()
    (chdir ?*route*)
    (load-utilities)
    (load-standard)
)



