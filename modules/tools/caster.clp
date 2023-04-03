; Caster que anuncia el estado del programa base a los jugadores
; Las reglas especiales deben tener un caster personalizado

; FUNCIÓN MANEJO DE CASTEO
(deffunction TOOLS::cast (?cast)
    (bind ?*cast-activated* ?cast)
)

; FASES REGULARES
(defrule TOOLS::cast-begin-turn (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage start))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Beginning ?p turn)
)

(defrule TOOLS::cast-untap-phase (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 0 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Starting untapping phase of ?p)
)

(defrule TOOLS::cast-organization-phase (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 1 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Starting organization phase of ?p)
)

(defrule TOOLS::cast-organization-actions (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 1 1 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ?p Choose your organization phase actions)
)

(defrule TOOLS::cast-long-events-phase (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 2 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Starting long events phase of ?p)
)

(defrule TOOLS::cast-long-events-r-discard (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 2 1 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Discarding all long events resources of ?p)
)

(defrule TOOLS::cast-long-events-play (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 2 2 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ?p Play your long events resources)
)

(defrule TOOLS::cast-long-events-a-discard (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 2 3 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Discarding all long events adversities of ?p)
)

(defrule TOOLS::cast-movement-phase (declare (salience ?*universal-rules-salience*))
    (phase (player ?p) (stage 3 0))
    (test (eq TRUE ?*cast-activated*))
    =>
    (announce ALL Starting movement phase of ?p)
)

; FASES EVENTUALES
(defrule TOOLS::cast-reveal-move (declare (salience ?*universal-rules-salience*))
	(phase (player ?p) (stage $? move-fellowship ?f 0))
    (test (eq TRUE ?*cast-activated*))
	=>
	
	; O bien se dice al jugador que se mueve
	(bind ?moves (do-for-instance ((?event EVENT))
		(and
			(eq ?event:event-descriptor FELLOWSHIP-move)
			(eq (send ?event get-data fell) ?f)
		) 
		(announce ALL The fellowship ?f is moving to (send ?event get-data to))
	))
	
	; O se le dice que se queda
	(if (not ?moves)
	then
		(do-for-fact ((?in in))
			(and
				(send ?in:over is-a LOCATION)
				(eq ?in:under ?f)
			)
			(announce ALL The fellowship ?f decides to stay in ?in:over)
		)
	)
)