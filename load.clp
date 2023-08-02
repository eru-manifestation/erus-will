(defglobal ?*route* = "C:\Users\Pablo\Documents\GitHub\erus-will")

; Cargo el modulo tools
(deffunction load-tools ()
    (chdir ?*route*)
    (load* "modules\\tools\\innit.clp")
    (load* "modules\\tools\\object-prelude.clp")
    (load* "modules\\tools\\objects.clp")

    ;game-settings
    (load* "modules\\tools\\game-settings\\game-settings.clp")
    (load* "modules\\tools\\game-settings\\global-constants.clp")

    ;events
    (load* "modules\\tools\\events\\DEF-events.clp")
    (load* "modules\\tools\\events\\events.clp")
    (load* "modules\\tools\\events\\event-phase.clp")

    (load* "modules\\tools\\in.clp")
    (load* "modules\\tools\\phase.clp")

    ;user-interaction
    (load* "modules\\tools\\user-interaction\\interaction.clp")
    (load* "modules\\tools\\user-interaction\\actions.clp")
    (load* "modules\\tools\\user-interaction\\caster.clp")
)

; Carga el modulo main
(deffunction load-main ()
    (chdir ?*route*)
    (load* "modules\\main\\innit.clp")
    (load* "modules\\main\\clock.clp")
    (load* "modules\\main\\untapping.clp")
    (load* "modules\\main\\organization.clp")
    (load* "modules\\main\\long-events.clp")
    (load* "modules\\main\\movement.clp")
)

; Carga el módulo move-fellowship
(deffunction load-move-fellowship ()
    (chdir ?*route*)
    (load* "modules\\move-fellowship\\innit.clp")
    (load* "modules\\move-fellowship\\event-phase.clp")
    (load* "modules\\move-fellowship\\move-fellowship.clp")
)

; Cargo todas los archivos
(deffunction load-all ()
    (chdir ?*route*)
    (load-tools)
    (load-main)
    (load-move-fellowship)
)



