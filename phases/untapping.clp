(defrule CARD-r0-0-2 (declare (salience ?*phase-salience*))
	; En la fase Enderezamiento, enderezar todas las cartas no localizaciones
	;
	; TODO:  crear message-handler is-a que se llamen entre ellos para obtener todas las clases
	;
	(phase (player ?p) (stage 0 1 1))
	(object (is-a CARD) (name ?c) (tap TAPPED) (player ?p))
	(test (not (send ?c is-a LOCATION)))
	=>
	(gen-event CARD-untap target ?c)
) 


(defrule r0-2-1 (declare (salience ?*phase-salience*))
	; Curar personajes y aliados heridos en refugios
	(object (is-a CHARACTER | ALLY) (name ?c) (tap WOUNDED))
	(object (is-a LOCATION) (name ?loc&:(is-haven ?loc)))
	(in (over ?loc) (under ?c))
	=>
	(gen-event CHARACTER-cure target ?c)
)
