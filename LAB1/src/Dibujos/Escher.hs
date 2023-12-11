module Dibujos.Escher (
    escherConf
) where

import Graphics.Gloss (line, pictures, polygon)
import Dibujo (Dibujo, figura, juntar, apilar, rot45, rotar, encimar, espejar, cuarteto, r270, r180, ciclar, complementar)
import FloatingPic (Output, half, zero, vacia)
import qualified Graphics.Gloss.Data.Point.Arithmetic as V
import Interp (Conf(..), interp)

data Basica = Triangulo | Nada
    deriving (Show, Eq)

type Escher = Basica

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar (encimar p1 (rotar p1)) 
                (encimar (r180 p1) (r270 p1)) 
        where p1 = espejar (rot45 p)

-- El dibujoT.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = encimar p (encimar p1 p2)
        where p1 = espejar (rot45 p)
              p2 = r270 p1

-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 0 p = figura Nada 
esquina n p = cuarteto (esquina (n-1) p) (lado (n-1) p) (rotar (lado (n-1) p)) (dibujoU p) 

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 0 p = figura Nada 
lado n p = cuarteto (lado (n-1) p) (lado (n-1) p) (rotar (dibujoT p)) (dibujoT p) 

-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x = apilar 2 1 (juntar 2 1 p (juntar 1 1 q r))
                          (apilar 1 1 (juntar 2 1 s (juntar 1 1 t u)) 
                                      (juntar 2 1 v (juntar 1 1 w x)))

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher n p = 
    noneto  (esquina n (figura p)) 
            (lado n (figura p))
            (r270 (esquina n (figura p)))          --(rotar (rotar (rotar (esquina n (figura p)))))
            (rotar (lado n (figura p)))
            (dibujoU (figura p))
            (r270 (lado n (figura p)))             --(rotar (rotar(rotar (lado n (figura p)))))
            (rotar (esquina n (figura p)))
            (r180 (lado n (figura p)))             --(rotar (rotar (lado n (figura p))))
            (r180 (esquina n (figura p)))          --(rotar (rotar (esquina n (figura p))))

interpBasica :: Output Escher
interpBasica Nada a b c = vacia a b c
interpBasica Triangulo a b c = pictures [line $ triangulo a b c, cara a b c]
  where
      triangulo a b c = map (a V.+) [zero, c, b, zero]
      cara a b c = polygon $ triangulo (a V.+ half c) (half b) (half c)


escherConf :: Conf
escherConf = Conf {
    name = "Escher",
    pic = interp interpBasica (escher 5 Triangulo)
}