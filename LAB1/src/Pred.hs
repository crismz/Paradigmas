{-# LANGUAGE LambdaCase #-}
module Pred (
  Pred,
  cambiar, anyDib, allDib, orP, andP
) where
import Dibujo (Dibujo, figura, foldDib, mapDib)

type Pred a = a -> Bool

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento
cambiar :: Pred a -> (a -> Dibujo a) -> Dibujo a -> Dibujo a
cambiar pred fun = mapDib (\case
                            x | pred x -> fun x
                              | otherwise -> figura x)

-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool
anyDib pred =
              foldDib
              pred                                -- Figura
              id                                  -- Rotar
              id                                  -- Espejar
              id                                  -- Rot45
              (\f1 f2 dib1 dib2 -> dib1 || dib2)  -- Apilar
              (\f1 f2 dib1 dib2 -> dib1 || dib2)  -- Juntar
              (||)                                -- Encimar

-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool
allDib pred =
              foldDib
              pred                                -- Figura
              id                                  -- Rotar
              id                                  -- Espejar
              id                                  -- Rot45
              (\f1 f2 dib1 dib2 -> dib1 && dib2)  -- Apilar
              (\f1 f2 dib1 dib2 -> dib1 && dib2)  -- Juntar
              (&&)                                -- Encimar       

-- Los dos predicados se cumplen para el elemento recibido. Pred a = a -> Bool
andP :: Pred a -> Pred a -> Pred a
andP p1 p2 x = p1 x && p2 x

-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP p1 p2 x = p1 x || p2 x
