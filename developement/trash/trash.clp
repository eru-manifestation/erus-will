
(defrule FELLOWSHIP-draw-on-stay-DEPRECATED
	; Estamos en la fase correcta
	(phase (player ?p) (stage $? move-fellowship ?f 1 1))
	
	; Dada la mano del jugador
	(object (is-a HAND) (player ?p) (name ?player-hand))
	=>
	(bind ?player-draw-limit 0)
	(bind ?enemy-draw-limit 0)
	; Si se mueve a un no refugio, el límite lo decide el destino
	(do-for-instance ((?event EVENT))
		(and
			(eq ?event:event-descriptor FELLOWSHIP-move)
			(eq ?event:type IN)
			(eq ?f (send ?event get-data fell)) 
		)
		(bind ?player-draw-limit (send (send ?event get-data to) get-player-draw))
		(bind ?enemy-draw-limit (send (send ?event get-data to) get-enemy-draw))
	)
	
	; Si no se mueve, o lo hace a un refugio, el límite lo decide la localización actual
	(if (neq 0 ?player-draw-limit)
		then
		(bind ?player-draw-limit (send (send ?event get-data from) get-player-draw))
		(bind ?enemy-draw-limit (send (send ?event get-data from) get-enemy-draw))
	)

	; Como mínimo, cada jugador debe robar una carta
	(gen-event HAND-draw player ?p)
	(gen-event HAND-draw player (enemy ?p))
	(gen-event HAND-multiple-draw player ?player max ?player-draw-limit)
	(gen-event HAND-multiple-draw player (enemy ?player) max ?enemy-draw-limit)
)
	




(load-all)
(init-handG)
(send [eomer1] put-tap TAPPED)
(watch instances)
(run)
(send [eomer1] get-tap)


(load-all)
(init-locations)
(init-handG)
(watch rules)
(run 8)
(run 1)



(defclass C1 (is-a USER) (slot value (type INTEGER)))
(make-instance c of C1 (value 2))

(defclass item (is-a USER) (slot value (type INTEGER)))
(defmessage-handler item init after ()
	(send [c] put-value (+ (send [c] get-value) ?self:value))
)
(defmessage-handler item delete before ()
	(send [c] put-value (- (send [c] get-value) ?self:value))
)

(defrule r1
	(logical (action))
	=>
	(make-instance of item (value 1))
)