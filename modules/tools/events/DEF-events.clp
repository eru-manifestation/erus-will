; DEFINICIÓN DE TEMPLATE EVENTO
(defclass TOOLS::EVENT (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared) (visibility public))
	(slot state (type SYMBOL) (default ONGOING) (allowed-symbols ONGOING COMPLETED DEFUSED) (visibility public))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario (ANTIGUO)
)

(deffunction get-active())

(defclass TOOLS::EVENT-PHASE (is-a EVENT)
    (slot previous (type INSTANCE-NAME) (allowed-classes EVENT-PHASE) (default-dynamic (get-active)))
	(slot state (type SYMBOL) (default ONGOING) (allowed-symbols ONGOING COMPLETED DEFUSED WAITING) (visibility public))
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER))
    (multislot stage (default (create$ start))) 

)

(deffunction get-active()
;PROBLEMA: ELIGE LA INSTANCIA QUE SE ESTÁ CREANDO (LIGERAMENTE SOLUCIONADO AL CAMBIAR EL ORDEN DE LOS ATRIBUTOS)
    (do-for-instance ((?e EVENT-PHASE)) (eq ?e:state ONGOING)
        (send ?e put-state WAITING)
        (return (instance-name ?e)))
    return [nil]
)

(defmessage-handler EVENT-PHASE activate()
    ; Si recibe el FOCO hay 2 opciones:
    ;   * Estaba WAITING y pasa a ONGOING
    ;   * Está DEFUSED y se lo pasa al siguiente
    ; No puede estar ONGOING, porque indica que el foco lo tiene ya, y por lo tanto no puede tenerlo otro que se lo ceda
    ; No puede estar COMPLETED, porque al lanzar el complete se le pasa el foco automáticamente al siguiente y este sale de la cadena
    (if (eq ?self:state WAITING)
        then
        (send ?self put-state ONGOING)
        else
        (send ?self:previous activate)
    )
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT HANDLER
(defmessage-handler EVENT complete()
	; Lo marca como terminado
	(send ?self put-state COMPLETED)
)

; MÉTODO PARA QUE SE MARQUE EL EVENTO COMO COMPLETADO EN UN EVENT HANDLER
(defmessage-handler EVENT-PHASE complete()
	; Lo marca como terminado
	(send ?self put-state COMPLETED)
    ; Si se termina, es porque el flujo de ejecución ha sido normal y según lo planeado, suponemos que esta fase eventual
    ; tenia el foco
    (if (neq ?self:previous [nil])
        then
        (send ?self:previous activate)
    )
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENTO
(defmessage-handler EVENT defuse ()
	; Desactiva el evento
	(send ?self put-state DEFUSED)
)

; MÉTODO PARA QUE NO SE LLEVE A CABO EL EVENTO
(defmessage-handler EVENT-PHASE defuse ()
	; Desactiva el evento
	(send ?self put-state DEFUSED)
    (if (neq ?self:previous [nil])
        then
        (if (eq ?self:state ONGOING)
            then
            (send ?self:previous activate)
        )
    )
)

; RECOLECTOR DE BASURA
(defrule TOOLS::event-garbage-collector (declare (auto-focus TRUE)) ;(salience ?*event-handler-salience*))
	; Destruye los eventos marcados como terminados o desactivados
	?e <- (object (is-a EVENT) (state COMPLETED | DEFUSED))
	=>
	(send ?e delete)
)