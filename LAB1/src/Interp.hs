module Interp (
    interp,
    Conf(..),
    interpConf,
    initial
) where

import Graphics.Gloss(Picture, Display(InWindow), makeColorI, color, pictures, translate, white, display)
import Dibujo (Dibujo, foldDib, figura)
import FloatingPic (FloatingPic, Output, grid, half, add, multiply, subs, neg)


-- Interpretación de un dibujo
-- formulas sacadas del enunciadoFloatingPic.
interp :: Output a -> Output (Dibujo a)
interp f = 
    foldDib 
    f                                                                            -- Figura                                    
    (\f x w h -> f (add x w) h (neg w))                                          -- Rotar
    (\f x w h -> f (add x w) (neg w) h )                                         -- espejar
    (\f x w h -> f (add x (half (add w h))) (half (add w h)) (half (subs h w)))  -- Rot45
    auxApilar                                                                    -- Apilar
    auxJuntar                                                                    -- Juntar
    (\f g x w h -> pictures[f x w h, g x w h])                                   -- Encimar
 
 
 -- Funciones auxialiares para usar con foldDib en interp

auxApilar :: Float -> Float -> FloatingPic -> FloatingPic -> FloatingPic         
auxApilar n m f g x w h = pictures [f (add x h') w (multiply r h), g x w h']
                        where r' = n / (m + n)       
                              r  = m / (m + n)
                              h' = multiply r' h  
                              
auxJuntar :: Float -> Float -> FloatingPic -> FloatingPic -> FloatingPic
auxJuntar n m f g x w h = pictures [f x  w' h, g (add x w') (multiply r' w) h]
                        where r' = n / (m + n)       
                              r  = m / (m + n)
                              w' = multiply r w  


-- Configuración de la interpretación
data Conf = Conf {
        name :: String,
        pic :: FloatingPic
    }

interpConf :: Conf -> Float -> Float -> Picture 
interpConf (Conf _ p) x y = p (0, 0) (x,0) (0,y)

-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: Conf -> Float -> IO ()
initial cfg size = do
    let n = name cfg
        win = InWindow n (ceiling size, ceiling size) (0, 0)
    display win white $ withGrid (interpConf cfg size size) size size
  where withGrid p x y = translate (-size/2) (-size/2) $ pictures [p, color grey $ grid (ceiling $ size / 10) (0, 0) x 10]
        grey = makeColorI 120 120 120 120