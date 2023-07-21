;/////////////////// FASE 0 0: INICIO FASE ENDEREZAMIENTO ////////////////////////

;/////////////////// FASE 0 1 0: INICIO ENDEREZAR PERSONAJES GIRADOS ////////////////////////

;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////

; EVENTO: En la fase Enderezamiento, enderezar todas las cartas no localizaciones
(defrule MAIN::CARD-r0-0-2 (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 0 1 1))

	(object (is-a CARD) (name ?c) (tap TAPPED) (player ?p))
	(test (not (send ?c is-a LOCATION)))
	=>
	(gen-event CARD-untap target ?c)
) 


;/////////////////// FASE 0 1 2: FIN ENDEREZAR PERSONAJES GIRADOS ////////////////////////

;/////////////////// FASE 0 2 0: INICIO CURAR PERSONAJES EN REFUGIOS ////////////////////////

;/////////////////// FASE 0 2 1: EJECUCION CURAR PERSONAJES EN REFUGIOS ////////////////////////

; EVENTO: Curar personajes y aliados heridos en refugios
(defrule MAIN::r0-2-1 (declare (salience ?*phase-salience*))
	; Estamos en la fase correcta
	(phase (player ?p) (stage 0 2 1))

	(object (is-a CHARACTER | ALLY) (name ?c) (tap WOUNDED))
	(object (is-a LOCATION) (name ?loc&:(is-haven ?loc)))
	(in (over ?loc) (under ?c))
	=>
	(gen-event CHARACTER-cure target ?c)
)


;/////////////////// FASE 0 2 2: FIN CURAR PERSONAJES EN REFUGIOS ////////////////////////

;/////////////////// FASE 0 3: FIN FASE ENDEREZAMIENTO ////////////////////////



