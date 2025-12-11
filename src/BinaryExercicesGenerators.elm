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


type alias ExercisesData =
    { dec2bin : List Int
    , bin2dec : List Int
    , addition : List ( Int, Int )
    , dec2binNeg : List Int
    , bin2decNeg : List Int
    , additionRelative : List ( Int, Int )
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
        |> andMap conversionNumbers
        |> andMap conversionNumbers
