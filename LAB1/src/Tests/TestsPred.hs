module Tests.TestsPred () where

import Test.HUnit (assertEqual, Test(TestList, TestCase), runTestTT)

import Pred (Pred, cambiar, anyDib, allDib, orP, andP)

import Dibujo (Dibujo, figura, rotar, espejar, rot45, apilar,
                juntar, encimar, foldDib, mapDib, figuras)

-- Test de cambiar

dibujo :: Dibujo Int
dibujo  = espejar (apilar 0 0 (encimar (figura 1) (figura 2))
            (juntar 0 0 (rot45 (figura 1)) (rotar (figura 3))))


dibujo2 :: Dibujo Int
dibujo2  = espejar (apilar 0 0 (encimar (figura 1) (figura 1))
            (juntar 0 0 (rot45 (figura 1)) (rotar (figura 1))))

expectedcambiar :: String
expectedcambiar =
    "Espejar (Apilar 0.0 0.0 (Encimar (Rotar (Figura 1)) (Figura 2)) (Juntar 0.0 0.0 (Rot45 (Rotar (Figura 1))) (Rotar (Figura 3))))"

testcambiar :: Test
testcambiar = TestCase (assertEqual "cambiar"
                          expectedcambiar
                            (show $ cambiar (==1) (rotar . figura) dibujo))

-- Test de anyDib

testanyDibTrue :: Test
testanyDibTrue = TestCase (assertEqual "anyDibTrue" True (anyDib (==1) dibujo))

testanyDibFalse :: Test
testanyDibFalse = TestCase (assertEqual "anyDibFalse" False
                                        (anyDib (== 4) dibujo))

-- Test de allDib

testallDibTrue :: Test
testallDibTrue = TestCase (assertEqual "allDibTrue" True (allDib (==1) dibujo2))

testallDibFalse :: Test
testallDibFalse = TestCase (assertEqual "allDibFalse" False (allDib (==1) dibujo))

-- Test de andP

testandPTrue :: Test
testandPTrue = TestCase (assertEqual "andPTrue" True (andP (==1) (>0) 1))

testandPFalse :: Test
testandPFalse = TestCase (assertEqual "andPFalse" False (andP (==1) (>0) 2))

-- Test de orP

testorPTrue :: Test
testorPTrue = TestCase (assertEqual "orPTrue" True (orP (==1) (<0) 1))

testorPFalse :: Test
testorPFalse = TestCase (assertEqual "orPFalse" False (orP (==1) (<0) 2))


tests :: Test
tests = TestList [testcambiar, testanyDibTrue, testanyDibFalse,
                    testallDibTrue, testallDibFalse, testandPTrue,
                    testandPFalse, testorPTrue, testorPFalse]