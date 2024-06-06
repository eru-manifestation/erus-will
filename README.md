# erus-will
A project dedicated to SATM

Para iniciar el juego, abrir el ejecutable load.bat

Seguir los pasos:
    * Cargar todos los elementos del juego: (load-all)

    * Iniciar localizaciones: (init-locations)

    * Iniciar mano de Gandalf: (init-handG)

    * Arrancar funcionamiento: (run)

Gestionar el modo debug en compulsory-division/main-utilities/game-settings/game-settings.clp


# GUIA DE DESARROLLO:

El sistema está dividido de forma que cada uno de las fases están expresadas declarativamente de forma que a cada subfase mínima se le asigna un módulo CLIPS en el que se ejecuten sus reglas. De esta forma se obtiene:

    I) Independencia en la ejecución de las fases: Las reglas de cada módulo solo pueden activarse si dicho módulo tiene el "foco". Esta estructura idea clips para separar el programa en tareas independientes con la capacidad de alternarse mediante llamadas. Con esto, se evita el uso de un elemento "fase" que itere con su valor entre los nombres de las distintas subfases del programa, lo cual resulta computacionalmente costoso en el algoritmo RETE que implementa CLIPS.

    II) Interactividad entre las fases: Si bien existen maneras de hacer que ciertos datos se mantengan propios y privados a cada fase (módulo CLIPS), existen elementos llamados "instancias", los cuales son propiamente instancias de clases CLIPS que se comparten en todo el "CLIPS enviroment".

    III) Mantener el panorama declarativo en términos de escalado: La razón principal para llevar a cabo este proyecto con CLIPS y no con un lenguaje de programación funcional más usual y de más fácil acceso (como Java, C, C++ o python) radica en la sencillez de adaptar el lenguaje humano al paradigma de programación declarativo. Este además permite la inserción de nuevos preceptos (o "reglas" CLIPS), conceptos (estructuras de datos como "template" o "class") que permiten al programa aumentar su capacidad de representación del problema (en este caso, sería aumentar la diversidad de elementos de juego) sin necesidad de reformar iterativamente la estructura del programa base (o juego con los elementos más básicos posibles).

# Mantener y estabilizar el flujo del programa con módulos
Si bien el sistema modular elegido es atractivo por las propiedades descritas anteriormente, son necesarios ciertos ajustes para conseguir un funcionamiento ajustado a las características desadas del programa, las cuales se resumen en:

    I) Existencia de un flujo principal del programa, que recorra todas las fases del juego en orden. Debe de ser lo suficientemente robusto como para no permitir errores en la selección de fase pero flexible a su vez para permitir pequeñas "trampas" o comportamientos disruptivos previstos con antelación por reglas futuramente añadidas.

    II) Capacidad de albergar un flujo temporal. No solo el juego debe fluir hacia adelante, sino hacia arriba a veces, implicando la existencia de lo que llamo "fases eventuales". Estas serían pequeños fragmentos de flujo del programa que se llaman arbitrariamente durante la ejecución del mismo. Una fase enventual debe ser concisa y tener una tarea firmemente definida, aceptar la división en varias subfases que la compongan, no disrumpir la estructura de datos o flujo subyacente, permitir a su vez la llamada de otras "fases eventuales" (hemos supuesto, siempre una diferente a la anterior y no repetida en la pila de foco actual), mantener el panorama declarativo (pues ciertos futuros elementos del programa podrán necesitar actuar en esas fases o incluso interactuar diréctamente con su flujo de ejecución) y devolver el foco a la fase o fase eventual que la llamó.

    III) Capacidad de ejecutar la tarea asignada a cada fase las veces que sea necesaria, permitiendo su reinicio, de ser necesario.

Después de varios intentos, pruebas y estimaciones se ha decidido llevar a cabo lo siguiente:

    * Hacer una estructura unificada que mantenga la integridad del flujo del programa "clock.clp", con herramientas para asegurar las funciones:
        - Avance del flujo del programa
        - Salto entre distintas fases del mismo
        - Reconocimiento de la fase actual
    
    * Confeccionar un elemento representativo de los datos a transmitir en el flujo de una fase eventual, ya que debe estar encapsulada en sí misma para no destruir la estructura de datos subyacente.



# Sobre el sistema de información

De la necesidad de adaptar el programa base a sus futuras (e impredecibles) expansiones surge el sistema de información pseudo-dinámico. Podemos dividir el modo en el que se recibe la información que posee el programa en dos partes fundamentales: consistente e inconsistente.

La información consistente es aquella que promueve una concepción fidedigna del estado del programa, donde se puede asimilar al estado de una partida real del juego de mesa.

La información inconsistente es obtenida disrumpiendo la ejecución de las reglas diseñadas para dar apoyo y coherencia al programa. Estas reglas acostumbran a ejecutarse independientemente del módulo que esté en acción al momento. Su función es crear un sistema de información estable y confiable en el que las demás reglas (las que añada el juego) puedan activarse sin temor a permanecer en un estado indeterminado, solo concebible en el mundo computacional y no el real. Un ejemplo de esto sería una regla que realice en un juego de última generación el ajuste gravitatorio de los personajes, en general, hablan de verdades que se suponen y evitan inconsistencias. Estan marcadas con la saliencia "?*universal-rules-salience*".

Como se puede atisbar según la división de información anterior, las reglas que forman la ejecución del programa están estratificadas según su propósito. De mayor prioridad a menor:
    * universal-rules: reglas para mantener la coherencia del sistema.
    * action-population: exclusivo para reglas con como único resultado la presentación al usuario de una posible acción a realizar.
    * action-selection: exclusivo para la interacción con el usuario. Debe ocurrir después de que se hayan propuesto todas las opciones para el jugador.
    * event-interception: mecanismo para intervenir eventos, tanto antes de haberse manejado como después.
    * event-handler: acción principal de un evento, para el cuál fue diseñado. Inicio de fases eventuales.
    * garbage-collector: mecanismo eliminador de eventos.
    * clock: Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que se altere la fase en la que podrían ocurrir.



La creación de un programa que altere su funcionamiento de forma que cualquier instrucción esté sujeta a cambios imprevistos (como no llegar a ejecutarse, ser sustituida por otra, o desencadenar en ciertas ocasiones otras instrucciones) tiene unas consideraciones de eficiencia bastante complejas. Por ejemplo, cada vez que se cambia el valor de una variable, en un lenguaje de programación imperativo se deberá crear un evento que viaje a través de todos los objetos del programa. Este evento propaga la información del cambio que ha ocurrido. Posteriormente, se captura el evento en el elemento que lo necesite, se verifica un conjunto de otras características y se decide si ejecutar una sentencia a raíz de dicho evento y características comprobadas o no.

El esquema de funcionamiento descrito anteriormente es muy ineficiente, tanto en la propagación del evento (el cual en la amplia mayoría de casos no es necesario) como en la verificación de las demás características.

La alternativa propuesta es la implementación del algoritmo RETE de CLIPS, donde se pretende transformar un programa imperativo en su interpretación mediante el sistema CLIPS.

En el sistema propuesto, cada instrucción se convertirá en una regla que verifique las condiciones de ejecución de dicha instrucción y genere un objeto "intención" de la clase EVENT. Posteriormente este objeto será intepretado por reglas del programa que se ejecuten a raíz de este, creando otros EVENT. La finalidad es que el algoritmo RETE mejore la eficiencia temporal de la propagación del evento y las verificaciones de otras características de lo que hubiera sido un manejador de eventos del programa imperativo.

Para ejemplificar la necesidad de este sistema, se ha realizado la implementación del juego de mesa El Señor de Los Anillos la Tierra Media (SATM), donde cada carta añade un conjunto de condiciones que modificarán la ejecución de la partida.


LOS EVENTOS

Un evento no es más que una representación de la intención de ejecutar una acción sobre la base de hechos (conjunto de datos del programa). Esta intención se compone de tres partes:

1. Estado: Indica qué tipo de interpretación se está haciendo de la intención, si entrada, ejecución o cierre
2. Posición: Dirección del objeto EVENT al que ha interrumpido para ejecutarse
3. Datos: Argumentos necesarios para la ejecución de las acciones de la regla
4. Razones: Identifica el disparo de la regla (tanto la regla disparada como su el patrón de satisfacción)

Ahora, lo que sería un manejador de eventos del panorama imperativo se deberá transformar en una regla CLIPS que se ejecuten identificando el estado del evento, el evento del que surge (de haberlo) y el conjunto de razones que llevan a la ejecución del mismo.

La necesidad del campo estado es evidente, pues cierto manejador de evento puede requerir ejecutarse antes o después de la ejecución del evento. Aquí, como veremos más adelante, se da la opción de cancelar completamente el evento, por lo que habrá además un estado indicado para ello (IN).

La posición se podría ver como uno de los argumentos de las razones, pero al ser tan común y al existir un sistema de posicionamiento por otros motivos, se decide reutilizarlo para el sistema de eventos.

El campo más importante es el de razones. Este campo contiene los elementos necesarios para que la interpretación sobre qué cambio se intenta efectuar sea la correcta. Ejemplo: al intentar cambiar el estado de un personaje a herido, debe tener un par "slot estado" y otro "new HURT", que proveerán la información necesaria para ejecutarlo.

Inicialmente, uno podría pensar que los elementos del programa que representan objetos reales del juego (lo que serían objetos, variables o constantes en otro lenguaje de programación) interactúan de manera natural entre sí. Ejemplo: la intención de cambiar la posición de un objeto de un personaje a otro del juego, podría parecer lo suficientemente clara (transferir un objeto de forma normal). Sin embargo, si el personaje que pierde el objeto está a punto de ser eliminado, las reglas que interceptarán esta intención son distintas.
Además, hay casos donde la intención que nos llevó a ejecutar una instrucción condicionará las intercepciones de la misma por otros eventos. 

Podríamos pensar en revisar a posteriori las condiciones necesarias para interpretar en el momento el tipo de evento que se intenta, pero esto es incorrecto, puesto que dichas condiciones pueden cambiar desde que se ejecutó la regla. El problema radica en pensar que un cambio en la base de hechos proviene de los hechos que representan objetos del programa, cuando en realidad proviene de la propia regla que lanza el EVENT.

Por tanto, solo tendríamos que añadir el nombre de la regla que lanza el evento dentro del campo "razones". Ahora podemos entender qué ha provocado este cambio, pues la propia activación de la regla será la comprobación de las características necesarias para la interpretación, como es evidente.

Sin embargo, surge otro problema a la hora de interpretar objetos EVENT. Escribir el nombre de la regla que lanza el evento junto a las características necesarias para su ejecución final solo nos dice qué regla (refiriéndose ahora a la propia regla del juego SATM que motiva una regla CLIPS) se ejecuta. Esto significa que ignoramos qué elementos del juego han sido los que satisfacen las reglas del juego, por lo que perdemos capacidad de interpretar este EVENT. Lo podemos solucionar añadiendo un par por cada elemento necesario para satisfacer la regla.

Ejemplo:

1. Sin "reason" (sólo información sobre cómo ejecutarlo): 
    - P1: "Pongo este anillo bajo Gandalf"
    - P2: "¿Pero para qué? ¿Moverlo? ¿Hacerle una prueba al anillo? ¿Qué regla del juego te permite hacerlo?

2. Con "reason" pero sin identificación del disparo de regla:
    - P1: "Pongo esta criatura enemiga en la compañía 1, según la regla 'atacar-con-criatura-por-region'"
    - P2: "¿Pero estás atacando en ese lugar gracias a que es un bosque o porque es tierra libre? ¿De qué características exactas te vales para hacer eso?"

3. Con "reason" al completo:
    - P1: "Pongo esta criatura enemiga en la compañía 1, según la regla 'atacar-con-criatura-por-region' satisfecha por 'region bosque'"
    - P2: "Esta condición entorpece los ataques a raíz de regiones de bosque, por lo que debes aplicarla, etc." 


Para simplificar la intercepción de eventos, las reglas que lo realicen se llamarán "EI-nombre-inteceptor" y se agruparán las reglas interceptadas en categorías a las que se les apliquen EI's comunes. Ejemplo: JUGAR, JUGAR-PERSONAJE, JUGAR-OBJETO, DESCARTAR, etc. Además, solo crearemos estas categorías y los pares de satisfacción de la regla cuando uno o más EI's lo requieran, evitando complejidad extra del programa.