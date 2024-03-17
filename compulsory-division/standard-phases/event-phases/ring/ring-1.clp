(defmodule ring-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices => (E-roll-dices RING-TEST-ROLL ring-1::roll-dices))

; TODO: TESTING
(defrule a-play-magic-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
		(object (is-a E-phase) (reason dices RING-TEST-ROLL $?) (state DONE) (res ?d))
    	(data (phase ring) (data ring ?ring))
		(object (name ?ring) (magic-ring ?mr&:(<= ?d ?mr)))
		(object (is-a MAGIC-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?magic-ring))
		(test (eq ?p (send ?ring get-player)))
	)
	=>
	(assert (action
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar anillo magico " ?magic-ring))
		(identifier ?magic-ring)
		(data (create$ ?magic-ring position (send ?ring get-position))) 
		(reason PLAY RING ring-1::a-play-magic-ring)
	))
)

(defrule a-play-dwarven-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
		(object (is-a E-phase) (reason dices RING-TEST-ROLL $?) (state DONE) (res ?d))
    	(data (phase ring) (data ring ?ring))
		(object (name ?ring) (dwarven-ring ?dr&:(>= ?d ?dr)))
		(object (is-a DWARVEN-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?dwarven-ring))
		(test (eq ?p (send ?ring get-player)))
	)
	=>
	(assert (action
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar anillo enano " ?dwarven-ring))
		(identifier ?dwarven-ring)
		(data (create$ ?dwarven-ring position (send ?ring get-position))) 
		(reason PLAY RING ring-1::a-play-dwarven-ring)
	))
)

(defrule a-play-the-one-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
		(object (is-a E-phase) (reason dices RING-TEST-ROLL $?) (state DONE) (res ?d))
    	(data (phase ring) (data ring ?ring))
		(object (name ?ring) (one-ring ?or&:(>= ?d ?or)))
		(object (is-a THE-ONE-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?one-ring))
		(test (eq ?p (send ?ring get-player)))
	)
	=>
	(assert (action
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar El Anillo Unico"))
		(identifier ?one-ring)
		(data (create$ ?one-ring position (send ?ring get-position))) 
		(reason PLAY RING ring-1::a-play-the-one-ring)
	))
)

(defrule a-lesser-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
		(object (is-a E-phase) (reason dices RING-TEST-ROLL $?) (state DONE))
    	(data (phase ring) (data ring ?ring))
		(object (name ?ring) (player ?p) (position ?pos))
		(not (object (is-a STACK) (name ?pos)))
	)
	=>
	(assert (action
		(player ?p)
		(event-def modify)
		(description (sym-cat "Descartar el anillo, es solo un anillo menor"))
		(identifier PASS)
		(data (create$ ?ring position (discardsymbol ?p))) 
		(reason DISCARD ITEM ring-1::a-lesser-ring)
		(blocking TRUE)
	))
)



(defrule EI-discard-ring (declare (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (reason $? PLAY RING $?))
	(data (phase ring) (data ring ?ring))
    (not (object (is-a EVENT) (position ?e) (reason $? ring-1::EI-discard-ring)))
	=>
	(message "El anillo de oro se ha transformado")
	(E-modify ?ring position (discardsymbol (send ?ring get-player))
		DISCARD ring-1::EI-discard-ring)
)