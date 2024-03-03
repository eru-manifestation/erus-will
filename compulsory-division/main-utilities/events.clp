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
			(println "STAM_ERROR: Incorrect event state")
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
			;TODO: ciclo infinito, cuidado
			(returnFocus ?self:position)
			DEFUSED)
		(default 
			(println "STAM_ERROR: Incorrect event state")
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

(defmessage-handler E-modify init after ()
	(send ?self modify old (send ?self:target (sym-cat get- ?self:slot)))
)

;;;;;;;;;;;;;;;;;;;;;; GENERATORS TODO: Quitar ?target, esta sin uso

(deffunction MAIN::E-modify (?target ?slot ?newValue $?reason)
	(make-instance (gen-name E-modify) of E-modify (target ?target) (slot ?slot) (new ?newValue) (reason $?reason))
)

(deffunction MAIN::E-cancel (?target $?reason)
	(make-instance (gen-name E-modify) of E-modify (target ?target) (slot state) (new DEFUSED) (reason CANCEL $?reason))
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
	(bind ?phase (nth$ 1 (send ?e get-reason)))

	(send ?e modify state 
		(switch ?oldState
			(case IN then 
				(jump (sym-cat START- ?phase))
				;TODO no modify si data es vacio
				(decompressData ?phase (send ?e get-data))
				(send ?e modify data (create$))
				EXEC)
			(case OUT then DONE)
	))
)


(deffunction complete (?exitCode)
	(if (eq (send ?*active-event* get-state) EXEC) then
		(send ?*active-event* modify data (compressData (nth$ 1 ?self:reason)))
		(send ?*active-event* modify res ?exitCode)
		(send ?*active-event* modify state OUT)
		(pop-focus)
		else
		(println "SATM_ERROR: Incorrect event state")
	)
)
