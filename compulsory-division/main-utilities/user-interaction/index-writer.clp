(deffunction MAIN::upcase-first (?word)
    (sym-cat (str-cat (upcase (sub-string 1 1 ?word)) (sub-string 2 (str-length ?word) ?word)))
)

(deffunction MAIN::classes (?instance)
    (lowcase (str-cat (class ?instance) " " (implode$ (class-superclasses (class ?instance) inherit))))
)

(deffunction MAIN::instance-name-to-file (?instance)
    ;Elimina numero, utilizo el nombre de la clase
    (bind ?instance (lowcase (class ?instance)))
    ;Primera letra siempre en mayuscula
    (bind ?instance (upcase-first ?instance))
    ;Guion a espacio y doble guion desaparece porque la siguiente comienza en minuscula
    (bind ?instance (str-cat ?instance))
    (bind ?instance (str-replace ?instance "--" ""))
    (bind ?instance (str-replace ?instance "-" " "))
    ;Letra despues de espacio a mayuscula si su palabra no es "a an and the of or ..."
    ;Convertir "A fair travel in the border lands" en ("A" "fair" "travel" "in" "border" "lands")
    (bind ?instance (explode$ ?instance))
    (bind ?res (create$))
    (foreach ?word ?instance do
        (if (member$ (str-cat ?word) (create$ "a" "an" "and" "of" "the" "or" "in" "out")) then
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) ?word))
            else
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) (upcase-first ?word)))
        )
    )
    (bind ?res (implode$ ?res))
    (return (str-replace ?res " " ""))
)

(deffunction MAIN::bgstyle-icon (?card)
    (if (not (member$ (class ?card) (create$ FELLOWSHIP PLAYER))) then
        return (str-cat "style=\"background-image: url('../tw/icons/" (instance-name-to-file ?card) ".jpg');\"")
        else 
        return ""
    )
)

(deffunction MAIN::bgstyle-card (?card)
    (if (not (member$ (class ?card) (create$ FELLOWSHIP PLAYER))) then
        return (str-cat "style=\"background-image: url('../tw/" (instance-name-to-file ?card) ".jpg');\"")
        else 
        return ""
    )
)



(deffunction MAIN::update-under (?card ?level)
    (do-for-all-facts ((?in in)) 
        (and
            (eq ?in:transitive FALSE)
            (eq ?in:over ?card)
        )
        (bind ?game-element "")
        (bind ?style "")
        (if (not (member$ (class ?in:under) (create$ FELLOWSHIP PLAYER))) then 
            (bind ?game-element " game-element"))
        (loop-for-count ?level (printout html tab))
        (printout html (str-cat "<div class='level-" ?level " " (classes ?in:under) ?game-element "'" (bgstyle-icon ?in:under) ">") crlf) 
        (update-under ?in:under (+ 1 ?level))
        (loop-for-count ?level (printout html tab))
        (printout html "</div>" crlf)
    )
)

(deffunction MAIN::write-sidebars ()
    (printout html "<div class='sidebar sidebar-left'>" crlf)
    (do-for-all-instances ((?card CARD) (?ownable CARD)) 
        (and (eq ?card ?ownable) 
            (eq (send ?card get-state) HAND) 
            (eq (send ?card get-player) (symbol-to-instance-name player1))
        )
        (printout html tab (str-cat "<div class='" (classes ?card) " game-element'" (bgstyle-card ?card) "></div>") crlf)
    )
    (printout html "</div>")
    (printout html "<div class='sidebar sidebar-right'>")
    (do-for-all-instances ((?card CARD) (?ownable CARD)) 
        (and (eq ?card ?ownable) 
            (eq (send ?card get-state) HAND) 
            (eq (send ?card get-player) (symbol-to-instance-name player2))
        )
        (printout html tab (str-cat "<div class='" (classes ?card) " game-element'" (bgstyle-card ?card) "></div>") crlf)
    )
    (printout html "</div>")
)


; Escribe el archivo index.html
(deffunction MAIN::update-index ()
    (open "www\\index.html" html "w")
    (printout html "<!DOCTYPE html> <html lang='en-us'> <head> <meta charset='utf-8'> <meta name='viewport' content='width=device-width'>" crlf "<link rel='stylesheet' href='styles.css'>" crlf "</head>" crlf "<body>" crlf "<div class='container'>" crlf)
    (printout html "<div class='top-bar'>" crlf "<div class='mp-counter player1'>" (send [player1] get-mp) "</div>" crlf "<div class='mp-counter player2'>" (send [player2] get-mp) "</div>" crlf "</div>")
    (printout html "<div class='panel'>")
    (do-for-all-instances ((?loc LOCATION)) (any-factp ((?in in)) (and (eq ?in:transitive FALSE) (eq ?in:over (instance-name ?loc)) (eq (send ?in:under get-empty) FALSE)))
        (printout html "<div class='level-0 game-element' " (bgstyle-card ?loc) ">" crlf) 
        (update-under (instance-name ?loc) 1)
        (printout html "</div>" crlf)
    )
    (printout html "</div>")
    (write-sidebars)
    (printout html "</div> </body> </html>" crlf)
    (close html)
)