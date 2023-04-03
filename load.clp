(defglobal ?*route* = "D:+  SATM\\erus-will\\")

; Cargo herramientas del juego (miscelanea)
(deffunction load-miscelaneous ()
    (chdir ?*route*)
    (load* "miscelaneous\\global-constants.clp")
    (load* "miscelaneous\\events.clp")
    (load* "miscelaneous\\in.clp")
    (load* "miscelaneous\\interaction.clp")
    (load* "miscelaneous\\phase.clp")
    (load* "miscelaneous\\actions.clp")
    (load* "miscelaneous\\caster.clp")
)

; Carga las reglas dedicadas a las fases
(deffunction load-phases ()
    (chdir ?*route*)
    (load* "phases\\untapping.clp")
    (load* "phases\\organization.clp")
    (load* "phases\\long-events.clp")
    (load* "phases\\movement.clp")
)

; Cargo todas los archivos
(deffunction load-all ()
    (chdir ?*route*)
    (load* "miscelaneous\\object-prelude.clp")
    (load* "objects.clp")
    (load* "miscelaneous\\game-setting.clp")
    (load-miscelaneous)
    (load-phases)
)



