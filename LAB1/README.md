## Preguntas

#### ¿Por qué están separadas las funcionalidades en los módulos indicados?

Separar la funcionalidad en distintos modulos no solo ayuda a la legibilidad y a ordenar mejor el codigo, tambien nos permite asbtraernos de lo que realmente va a ser el dibujo para poder generalizarlo y asi utilizar cualquier tipo de dato. Esto nos ayuda a enfocarnos en un modulo especifico asumiendo que los demas funcionan y sin necesidad de preocuparnos sobre como estan implementados.

El modulo Dibujo.hs es donde definimos el tipo "Dibujo" y sus constructores, para evitar el uso de los mismos exportamos funciones constructoras y esquemas para la manipulacion de figuras. 

En Pred.hs definimos funciones de predicados sobre las figuras basicas.

Interp.hs por su parte se utiliza para interpretar geometricamente las figuras. Aqui utilizamos la libreria Gloss generar las figuras, para ello utilizamos los tipos y funciones sobre vectores definidas en FloatingPic.hs 

Main.hs lee la configuracion del dibujo pedido y lo muestra en pantalla. En caso de querer ver los dibujos registrados se puede llamar con el argumento "--lista" 

#### ¿Por qué las figuras básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

El no incluir las figuras basicas dentro de la definicion del lenguaje provee al usuario de mayor libertad a la hora de crear sus propias figuras.

#### ¿Qué ventaja tiene utilizar una función de fold sobre hacer pattern-matching directo?

El concepto de folding viene de una familia de funciones de "alto orden", estas funciones toman otras funciones como parametros o devuelven funciones como output.

El uso del "folding" nos ayuda a hacer el codigo mas legible, pues la intencion del programa queda mejor expresado. El escribir una funcion utilizando una funcion de fold indica que la intencion es iterar a traves de una lista o estructura de datos y aplicar una funcion a cada uno de sus elementos.

Tambien podemos "abstraer" el comportamiento de una funcion en otras funcionas mas simples las cuales serian pasadas como argumentos a una funcion fold, lo que nos provee de una mejor flexibilidad y simplicidad.

Por ultimo, utilizar folds en vez de otras tecnicas puede mejorar el rendimiento, pues gracias
a optimizaciones que el GHC sabe hacer a la hora de utilizar funciones de tipo fold, el compilador puede fusionar una serie de "folds" juntos en un solo ciclo durante la ejecucion.
