; FUNCION QUE DEFINE DÓNDE ESTÁ PENSADO QUE EXISTA EL EVENTO, LLAMADA AL SER SER COMPLETADO O DESACTIVADO 
(deffunction get-target-phase ()
	(bind ?phase (nth$ 2 (get-focus-stack)))
	(bind ?length (str-length ?phase))
	(bind ?index nil)
	(loop-for-count (?i 1 ?length) do
		(if (not (numberp (string-to-field (sub-string (- ?length ?i) ?length ?phase)))) then 
			(bind ?index ?i)
			(break)
		)
	)
	(string-to-field (sub-string 1 (- ?length ?index) ?phase))
)


(defmessage-handler E-modify exec ()
	(if (eq ?self:old (send ?self:target (sym-cat get- ?self:slot))) then
		(if (neq ?self:slot position) then
			(send ?self:target modify ?self:slot ?self:new)
			else
			(send ?self:target put-position ?self:new)
		)
		(send ?self modify state OUT)
		else
		(send ?self modify state DEFUSED)
	)
)

(defmessage-handler E-modify init after ()
	(send ?self modify old (send ?self:target (sym-cat get- ?self:slot)))
)


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
			(if (neq ?self:position (slot-default-value EVENT position)) then
				(send ?self:position unhold)
			)
			DEFUSED)
		(default 
			(println "STAM_ERROR: Incorrect event state")
			(halt)
			?self:state
		)
	))
)


(defmessage-handler EVENT init after ()
	(send ?self modify target-phase (get-target-phase))
;	TODO: usar una variable global que guarde el evento que se ejecute
	(do-for-instance ((?ep EVENT)) 
		(and (neq ?ep (instance-name ?self)) (or (eq EXEC ?ep:state) (eq IN ?ep:state) (eq OUT ?ep:state)))
		(send ?self put-position (instance-name ?ep))
		(send ?ep hold)
	)
)

(defmessage-handler EVENT put-state after (?newState)
	; Se presupone que si se desactiva es porque un cancelador ha actuado justo debajo de él e inmediatamente se pone DONE inmediatamente. Los cancelers son los únicos eventos cuya salida no se puede observar. Además, las salidas al ser cancelados no son observables tampoco.
	(if (eq ?newState DONE) then
		(if (neq ?self:position (slot-default-value EVENT position)) then
			(send ?self:position unhold)
		)
	)
)

;;;;;;;;;;;;;;;;;;;;;; GENERATORS

(deffunction MAIN::E-modify (?target ?slot ?newValue $?reason)
	(make-instance (gen-name E-modify) of E-modify (target ?target) (slot ?slot) (new ?newValue) (reason $?reason))
)

;	Como siempre se intercepta al único evento que haya en activo, 
; (deffunction MAIN::E-intercept (?target ?slot ?newValue ?intercepted $?reason)
; 	(make-instance (gen-name E-modify) of E-modify (target ?target) (slot ?slot) (new ?newValue) (position ?intercepted) (reason $?reason))
; )

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

(defrule MAIN::EN-phase (declare (auto-focus TRUE) (salience ?*E-next*))
	?e <- (object (is-a E-phase) (state IN | OUT))
	=>
	; E-phase no usa _
	(bind ?oldState (send ?e get-state))
	(send ?e modify state 
		(switch ?oldState
			(case IN then 
				(bind ?module (nth$ 1 (send ?e get-reason)))
				(bind ?module (jump (sym-cat START- ?module)))
				;	TODO: verificar que se percibe el hecho desde el modulo donde se aserta hasta el ultimo modulo de la fase eventual y ya esta
				(set-current-module ?module)
				(foreach ?fact (send ?e get-data) 
					(assert-string (str-cat "(data (data " ?fact "))"))
				)
				(set-current-module MAIN)
				(send ?e modify data (create$))
				EXEC)
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