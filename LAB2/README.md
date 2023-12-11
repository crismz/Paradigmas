# Informe

## Integrantes
- Cristian Ariel Muñoz
- Santiago Torres
- Damián Feigelmuller

## Lector de feeds
Funcionamiento:
```bash
$ javac FeedReaderMain.java
$ java FeedReaderMain
```

### feed 
Define 2 clases, una es `Article` que modela el contenido de un articulo de un Feed dado, mientras que `Feed` modela una lista de articulos, tiene metodos que nos permiten agregar y acceder a cada articulo.

### subscription
Define 2 clases, una es `SingleSubscription` que abstrae la información de una de las subscripciones contenidas en `subscriptions.JSON`, esto nos permite poder obtener la URL del feed que nos interesa.

`Subscription` por otro lado abstrae en su totalidad el contenido del archivo JSON, tiene como atributo una lista de `SingleSubscription`, define además métodos para agregar y obtener esta lista.  
 
### httpRequest
Este modulo define una la clase `HttpRequester` que se encarga de de realizar el pedido del feed.

Contiene un método para cada tipo de feed que toma una URL y devuelve una String con el feed completo que luego será procesado.

### Parser
El modulo define las clases necesarias para parsear tanto el archivo JSON como los feeds. 
Definimos en el archivo `GeneralParser` la clase que modela todos los atributos y metodos comunes a los parsers, todo parser de uso específico hereda de esta clase.

`SubscriptionParser` nos permite obtener la información contenida en el archivo `subscription.JSON` y almacenarla en un objeto de la clase `Subscriptions`.

`RssParser` nos permite pasar la informacion en String obtenida directamente del `httpRequester` y almacenarla en un objeto de la clase `Feed` (Es probable que solo funcione con feeds de la pagina de NYT). 

`RedditParser` tiene el mismo funcionamiento que `RssParser`, pero sirve especificamente para leer feeds de Reddit.

## Entidades nombradas

La aplicación tiene una funcionalidad extra que computa las *entidades nombradas* que se encuentran en el feed y su cantidad de ocurrencias. 

Se hizo una jerarquía de clases en el archivo `NamedEntityList`, donde todas las subclases heredan de entityName, y luego algunas de esas clases heredan a más subclases. También en el mismo archivo se hizo una interfaz para cada tema, para luego poder hacer las combinaciones entre el tipo de nameEntity (categoría) y su tema. Cada combinación hereda de alguna nameEntity e implementa una interfaz de algún tema, logrando asi simular la herencia múltiple que no se puede hacer de forma directa en java. Las combinaciones tambien se hicieron en el archivo `NamedEntityList`.

Para correr el programa con esta funcionalidad se debe agregar el argumento *-ne*


```bash
$ java FeedReaderMain -ne
``` 

Para hallarlas posibles entidades nombradas en el feed primero creamos una clase `StringProcesser` que mediante expresiones regulares filtra aquellas palabras que cumplen alguna caracteristica común de las entidades nombradas como palabras empezadas en mayúsculas, titulos como Doctor, Profesor, etc. Estas palabras las consideramos palabras "Candidatas".
Para la detección de entidades nombradas se definió la clase `Heuristic` que contiene los metodos comunes de cualquier heuristica que permita la detección de las entidades.

`RandomHeuristic` determina si una palabra es entidad nombrada de manera aleatoria, mientras que `QuickHeuristic` lo hace comparandola con un listado de palabras que no son consideradas como entidades nombradas. Creamos además otra heuristica que utiliza una inteligencia artificial que determina si una palabra es o no una entidad nombrada (se habla de la misma más abajo).  

Una vez encontradas las entidades nombradas las imprimimos por pantalla junto a su frecuencia.

# Puntos Estrella

## AIHeuristic

Hicimos una heurística que consulta a una AI, específicamente a OpenAI, para saber si la palabra es una entidad nombrada o no. La misma funciona de la siguiente forma: Se hace un pedido Http a la API con un mensaje donde se pregunta si tal palabra es una entidad nombrada, y que responda explícitamente con True o False. Y como el valor devuelto es un String se revisa, para que la función isEntity devuelva true o false correspondientemente a lo que devolvio la AI. 

La heurística no es funcional debido a que se hace un pedido Http por palabra, y como cada pedido tiene una pequeña demora, se hace inutilizable por lo que tardaria en consultar todas las palabras. Además de que al hacer demasiados pedidos en poco tiempo tira el error 429.

Para hacerlo funcional, una posibilidad es cambiar la heurística para que tome una lista de palabras y que devuelva una respuesta donde diga si cada palabra es una entidad o no (teniendo cuidado del tamaño de la lista, ya que el tamaño máximo entre pedido y respuesta es de 4000 tokens, que es aproximadamente igual a un poco menos de 3000 palabras). Pero para lograr eso, tendriamos que cambiar toda la estructura de la heurística general, o que la clase `AIHeuristic` sea  independiente de la heurística general (es decir que no herede de la misma) y por lo tanto cambiar el `FeedReaderMain`.


## RedditParser

Pudimos leer y mostrar por pantalla feeds de la pagina de Reddit haciendo uso de una libreria llamada org.json. Esta libreria nos permite manipular facilmente informacion en formato JSON, pues las respuestas de la API de reddit se presentan en este formato.

Una vez instanciada la clase JSONObject con el String obtenido de `httpRequester`, utilizamos los metodos get para acceder a campos especificos, leer sus valores, y almacenarlos en una instancia de la clase `Feed`.
