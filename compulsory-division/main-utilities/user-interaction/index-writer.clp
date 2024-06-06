; (deffunction MAIN::upcase-first (?word)
;     (sym-cat (str-cat (upcase (sub-string 1 1 ?word)) (sub-string 2 (str-length ?word) ?word)))
; )

; (deffunction MAIN::classes (?instance)
;     (lowcase (str-cat (class ?instance) " " (implode$ (class-superclasses (class ?instance) inherit))))
; )

; (defmessage-handler USER get-slots ()
;     ;Devolver una cadena con la asociacion entre slot y valor
;     (bind ?res "")
;     (foreach ?slot (class-slots (class ?self) inherit) 
;         (bind ?res (str-cat ?res ?slot "='" (implode$ (insert$ (create$) 1 (dynamic-get ?slot))) "'")))
;     (return ?res)
; )

; (deffunction MAIN::instance-name-to-file (?instance)
;     ;Elimina numero, utilizo el nombre de la clase
;     (bind ?instance (lowcase (class ?instance)))
;     ;Primera letra siempre en mayuscula
;     (bind ?instance (upcase-first ?instance))
;     ;Guion a espacio y doble guion desaparece porque la siguiente comienza en minuscula
;     (bind ?instance (str-cat ?instance))
;     (bind ?instance (str-replace ?instance "--" ""))
;     (bind ?instance (str-replace ?instance "-" " "))
;     ;Letra despues de espacio a mayuscula si su palabra no es "a an and the of or ..."
;     ;Convertir "A fair travel in the border lands" en ("A" "fair" "travel" "in" "border" "lands")
;     (bind ?instance (explode$ ?instance))
;     (bind ?res (create$))
;     (foreach ?word ?instance do
;         (if (member$ (str-cat ?word) (create$ "a" "an" "and" "of" "the" "or" "in" "out")) then
;             (bind ?res (insert$ ?res (+ 2 (length$ ?res)) ?word))
;             else
;             (bind ?res (insert$ ?res (+ 2 (length$ ?res)) (upcase-first ?word)))
;         )
;     )
;     (bind ?res (implode$ ?res))
;     (return (str-replace ?res " " ""))
; )

; (deffunction MAIN::bgstyle (?card)
;     (if (str-index " card " (classes ?card)) then
;         return (str-cat " style=background-image:url('../tw/icons/" (instance-name-to-file ?card) ".jpg') ")
;         else 
;         return ""
;     )
; )


; (deffunction MAIN::update-under (?player ?card)
;     (do-for-all-facts ((?in in)) 
;         (and
;             (eq ?in:transitive FALSE)
;             (eq ?in:over ?card)
;         )
;         (state ?player (str-cat "<div id='[" ?in:under "]' class='" (classes ?in:under) "' " (bgstyle ?in:under) (send ?in:under get-slots) " draggable=true >")) 
;         (update-under ?player ?in:under)
;         (state ?player "</div>" crlf)
;     )
; )


; (deffunction MAIN::draw (?player ?instance)
;     (state ?player (str-cat "<div id='[" ?instance "]' class='" (classes ?instance) "' " (bgstyle ?instance) (send ?instance get-slots) " draggable=true >") crlf) 
;     (update-under ?player ?instance)
;     (state ?player "</div>" crlf)
; )