;//////////////////////// FUNCTIONS

(deffunction MAIN::returnFocus (?previous)
	(bind ?*active-event* ?previous)
	(if (neq ?previous (slot-default-value BASIC position)) then
		(send ?previous unhold)
	)
)

(deffunction MAIN::passFocus (?newFocus)
	(if (neq (slot-default-value BASIC position) ?*active-event*) then
		(send ?*active-event* hold)
	)
	(bind ?*active-event* ?newFocus)
)



;////////////////////// EVENT

(defmessage-handler EVENT hold ()
	(send ?self modify state (switch ?self:state
		(case IN then IN-HOLD)
		(case EXEC then EXEC-HOLD)
		(case OUT then OUT-HOLD)
		(default 
			(println "SATM_ERROR: No se puede poner a la espera un evento en estado " ?self:state)
			(halt)
			?self:state
		)
	))
)

(defmessage-handler EVENT unhold ()
	(send ?self modify state (switch ?self:state
		(case IN-HOLD then IN)
		(case EXEC-HOLD then EXEC)
		(case OUT-HOLD then OUT)
		; En caso de que pase el mando a un evento desactivado, se entiende que quien le pasa el mando es el propio cancelador, que quiere que se le transfiera a su vez a quien tiene abajo, de haberlo
		(case DEFUSED then 
			(returnFocus ?self:position)
			DEFUSED)
		(default 
			(println "SATM_ERROR: No se puede reactivar un evento en estado " ?self:state)
			(halt)
			?self:state
		)
	))
)


(defmessage-handler EVENT init after ()
	(passFocus ?self)
)

(defmessage-handler EVENT put-state after (?newState)
	; Se presupone que si se desactiva es porque un cancelador ha actuado justo debajo de él e inmediatamente se pone DONE inmediatamente. Los cancelers son los únicos eventos cuya salida no se puede observar. Además, las salidas al ser cancelados no son observables tampoco.
	(if (eq ?newState DONE) then
		(bind ?self:active FALSE)
		(returnFocus ?self:position)
	)
)

;////////////////////// E-modify

(defmessage-handler E-modify exec ()
	;(if (eq ?self:old (send ?self:target (sym-cat get- ?self:slot))) then
		(if (neq ?self:slot position) then
			(send ?self:target modify ?self:slot ?self:new)
			else
			(send ?self:target put-position ?self:new)
		)
		(send ?self modify state OUT)
	;	else
	;	(send ?self modify state DEFUSED)
	;)
)

;;;;;;;;;;;;;;;;;;;;;; GENERATORS TODO:

(deffunction MAIN::E-modify (?target ?slot ?newValue ?reason)
	(make-instance (gen-name E-modify) of E-modify (target ?target) 
		(slot ?slot)
		(old (send ?target (sym-cat get- ?slot))) 
		(new ?newValue) 
		(reason ?reason))
)

(deffunction MAIN::E-play (?target ?newValue ?reason)
	(make-instance (gen-name E-play) of E-play (target ?target)
		(slot position)
		(old (send ?target get-position)) 
		(new ?newValue) 
		(reason ?reason))
)

(deffunction MAIN::E-play-by-region (?target ?newValue ?region ?reason)
	(make-instance (gen-name E-play-by-region) of E-play-by-region (target ?target)
		(slot position)
		(old (send ?target get-position)) 
		(new ?newValue) 
		(reason ?reason)
		(region ?region))
)

(deffunction MAIN::E-play-by-place (?target ?newValue ?place ?reason)
	(make-instance (gen-name E-play-by-place) of E-play-by-place (target ?target)
		(slot position)
		(old (send ?target get-position)) 
		(new ?newValue) 
		(reason ?reason)
		(place ?place))
)

(deffunction MAIN::E-discard (?target ?reason)
	(make-instance (gen-name E-discard) of E-discard (target ?target)
		(slot position)
		(old (send ?target get-position)) 
		(new (discardsymbol (send ?target get-player)))
		(reason ?reason))
)

(deffunction MAIN::E-cancel (?reason)
	(if (eq IN (send ?*active-event* get-state))
		then
		(make-instance (gen-name E-modify) of E-modify (target ?*active-event*) 
			(slot state) (new DEFUSED) (reason ?reason))
		else
		(println "SATM_ERROR: No se puede cancelar un evento en estado " (send ?*active-event* get-state))
		(halt)
	)
)

(deffunction MAIN::E-roll-dices (?dice-class ?reason)
	(make-instance (gen-name (sym-cat EP- ?dice-class)) of (sym-cat EP- ?dice-class) (reason ?reason))
)

;;;;;;;;;;;;;;;;;;;;; PHASING RULE

(defrule MAIN::EN-modify (declare (auto-focus TRUE) (salience ?*E-next*))
	?e <- (object (is-a E-modify) (state IN | EXEC | _ | OUT))
	=>
	(bind ?oldState (send ?e get-state))
	(send ?e modify state 
		(switch ?oldState
			(case IN then EXEC)
			(case EXEC then _)
			(case _ then DEFUSED)
			(case OUT then DONE)
	))
)

;TODO: Eliminar y cambiar por la doble comprobación
(defrule MAIN::E-exec (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?e <- (object (is-a E-modify) (state _))
	=>
	; Por ahora esta regla es tan imperativa como una función
	(send ?e exec)
)


;/////////////////////////// E-phase


(defrule MAIN::EN-phase (declare (auto-focus TRUE) (salience ?*E-next*))
	?e <- (object (is-a E-phase) (state IN | OUT))
	=>
	; E-phase no usa _
	(bind ?oldState (send ?e get-state))
	(bind ?phase (send ?e get-phase))

	(send ?e modify state 
		(switch ?oldState
			(case IN then 
				(message "Se inicia la fase " ?phase)
				(jump (sym-cat START- ?phase))
				EXEC)
			(case OUT then DONE)
	))
)


(deffunction complete (?exitCode)
	(bind ?state (send ?*active-event* get-state))
	(if (eq ?state EXEC) then
		(pop-focus)
		(send ?*active-event* modify res ?exitCode)
		(send ?*active-event* modify state OUT)
		else
		(println "SATM_ERROR: No se puede completar un evento en estado " ?state)
		(halt)
	)
)

(defmessage-handler E-phase put-state after (?state)
	(if (eq ?state OUT) then
		(message "Finaliza la fase " (send ?*active-event* get-phase))
	)
)