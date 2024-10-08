module BinaryExercicesGenerators exposing (ExercisesData, exercicesData)

import Random
import Random.Extra exposing (andMap)
import Random.List


xxs : Random.Generator Int
xxs =
    Random.int 3 4


xs : Random.Generator Int
xs =
    Random.int 5 7


s : Random.Generator Int
s =
    Random.int 8 15


m : Random.Generator Int
m =
    Random.int 16 127


l : Random.Generator Int
l =
    Random.int 128 255


xl : Random.Generator Int
xl =
    Random.int 256 511


neg : Random.Generator number -> Random.Generator number
neg gen =
    Random.map negate gen


conversionNumbers : Random.Generator (List Int)
conversionNumbers =
    Random.Extra.sequence
        [ s, l, xl ]


negativeConversionNumbers : Random.Generator (List Int)
negativeConversionNumbers =
    Random.Extra.sequence
        [ neg xs, neg s, neg m ]


addition : Random.Generator (List ( Int, Int ))
addition =
    Random.Extra.sequence
        [ Random.pair s m, Random.pair m l, Random.pair l m ]


additionRelative : Random.Generator (List ( Int, Int ))
additionRelative =
    Random.Extra.sequence
        [ Random.pair m (neg m), Random.pair m (neg m), Random.pair (neg s) (neg s) ]


multiplication : Random.Generator (List ( Int, Int ))
multiplication =
    Random.Extra.sequence
        [ Random.pair s xs, Random.pair m xs, Random.pair xxs xl ]


zip : Random.Generator (List a) -> Random.Generator (List b) -> Random.Generator (List ( a, b ))
zip gena genb =
    Random.map2 (List.map2 Tuple.pair) gena genb


shiftMultiplication : Random.Generator (List ( Int, Int ))
shiftMultiplication =
    zip
        (Random.constant [ 7, 127, 60 ])
        (Random.List.shuffle [ 2, 4, 8 ])


shiftDivision : Random.Generator (List ( Int, Int ))
shiftDivision =
    zip
        (Random.constant [ 5, 85, 240 ])
        (Random.List.shuffle [ 2, 4, 8, 16, 32 ])


type alias ExercisesData =
    { dec2bin : List Int
    , bin2dec : List Int
    , addition : List ( Int, Int )
    , dec2binNeg : List Int
    , bin2decNeg : List Int
    , additionRelative : List ( Int, Int )
    , shiftMultiplication : List ( Int, Int )
    , multiplication : List ( Int, Int )
    , shiftDivision : List ( Int, Int )
    , dec2hex : List Int
    , hex2dec : List Int
    }


exercicesData : Random.Generator ExercisesData
exercicesData =
    Random.map ExercisesData
        conversionNumbers
        |> andMap conversionNumbers
        |> andMap addition
        |> andMap negativeConversionNumbers
        |> andMap negativeConversionNumbers
        |> andMap additionRelative
        |> andMap shiftMultiplication
        |> andMap multiplication
        |> andMap shiftDivision
        |> andMap conversionNumbers
        |> andMap conversionNumbers
