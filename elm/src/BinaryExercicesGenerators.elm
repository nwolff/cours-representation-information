module BinaryExercicesGenerators exposing (ExercisesData, exercicesData)

import Random
import Random.Extra exposing (andMap)


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


{-
xxl : Random.Generator Int
xxl =
    Random.int (2 ^ 22) (2 ^ 23 - 1)
-}

neg : Random.Generator number -> Random.Generator number
neg gen =
    Random.map negate gen


conversionNumbers : Random.Generator (List Int)
conversionNumbers =
    Random.Extra.sequence
        [ s, l, xl ]


binhexConversionNumbers : Random.Generator (List Int)
binhexConversionNumbers =
    Random.Extra.sequence
        [ s, l, xl ]


relativeConversionNumbers : Random.Generator (List Int)
relativeConversionNumbers =
    Random.Extra.sequence
        [ neg xs, m, neg m ]


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
    , dec2binRelative : List Int
    , bin2decRelative : List Int
    , additionRelative : List ( Int, Int )
    , bin2hex : List Int
    , hex2bin : List Int
    , dec2hex : List Int
    , hex2dec : List Int
    , hex2decRelative : List Int
    }


exercicesData : Random.Generator ExercisesData
exercicesData =
    Random.map ExercisesData
        conversionNumbers
        |> andMap conversionNumbers
        |> andMap addition
        |> andMap relativeConversionNumbers
        |> andMap relativeConversionNumbers
        |> andMap additionRelative
        |> andMap binhexConversionNumbers
        |> andMap binhexConversionNumbers
        |> andMap conversionNumbers
        |> andMap conversionNumbers
        |> andMap relativeConversionNumbers
