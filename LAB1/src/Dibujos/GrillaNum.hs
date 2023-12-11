module Dibujos.GrillaNum (
    grillaConf
) where

import Dibujo (figura, Dibujo)
import Graphics.Gloss
    (text, translate, scale)
import Interp (Conf(..), interp)
import FloatingPic (FloatingPic, Output)
import Grilla (grilla)

fig :: String -> Dibujo String
fig = figura

cords :: Dibujo String
cords = grilla [
        [fig "(0,0)", fig "(0,1)", fig "(0,2)", fig "(0,3)", fig "(0,4)", fig "(0,5)", fig "(0,6)", fig "(0,7)"],
        [fig "(1,0)", fig "(1,1)", fig "(1,2)", fig "(1,3)", fig "(1,4)", fig "(1,5)", fig "(1,6)", fig "(1,7)"],
        [fig "(2,0)", fig "(2,1)", fig "(2,2)", fig "(2,3)", fig "(2,4)", fig "(2,5)", fig "(2,6)", fig "(2,7)"],
        [fig "(3,0)", fig "(3,1)", fig "(3,2)", fig "(3,3)", fig "(3,4)", fig "(3,5)", fig "(3,6)", fig "(3,7)"],
        [fig "(4,0)", fig "(4,1)", fig "(4,2)", fig "(4,3)", fig "(4,4)", fig "(4,5)", fig "(4,6)", fig "(4,7)"],
        [fig "(5,0)", fig "(5,1)", fig "(5,2)", fig "(5,3)", fig "(5,4)", fig "(5,5)", fig "(5,6)", fig "(5,7)"],
        [fig "(6,0)", fig "(6,1)", fig "(6,2)", fig "(6,3)", fig "(6,4)", fig "(6,5)", fig "(6,6)", fig "(6,7)"],
        [fig "(7,0)", fig "(7,1)", fig "(7,2)", fig "(7,3)", fig "(7,4)", fig "(7,5)", fig "(7,6)", fig "(7,7)"]
        ]

interpText :: Output String
interpText string x y w = translate (fst x + 10) (snd x + 20) 
                                $ scale 0.1 0.1 
                                $ text string

grillaConf :: Conf
grillaConf = Conf {
    name = "Grilla",
    pic = interp interpText cords
}