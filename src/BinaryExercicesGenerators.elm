module BinaryExercicesGenerators exposing (ExercisesData, exercicesData)

import Random exposing (Generator, constant, int, map, map2, pair)
import Random.Extra exposing (andMap, sequence)
import Random.List exposing (shuffle)


xxs : Generator Int
xxs =
    int 3 5


xs : Generator Int
xs =
    int 5 8


s : Generator Int
s =
    int 8 16


m : Generator Int
m =
    int 16 128


l : Generator Int
l =
    int 128 256


xl : Generator Int
xl =
    int 256 512


conversionNumbers : Generator (List Int)
conversionNumbers =
    sequence [ s, l, xl ]


addition : Generator (List ( Int, Int ))
addition =
    sequence [ pair s m, pair m l, pair l m ]


multiplication : Generator (List ( Int, Int ))
multiplication =
    sequence [ pair s xs, pair m xs, pair xxs xl ]


{-| Pulled this off by looking at the types
-}
zip : Generator (List a) -> Generator (List b) -> Generator (List ( a, b ))
zip gena genb =
    map2 (List.map2 Tuple.pair) gena genb


shiftMultiplication : Generator (List ( Int, Int ))
shiftMultiplication =
    zip
        (constant [ 7, 127, 60 ])
        (shuffle [ 2, 4, 8 ])


shiftDivision : Generator (List ( Int, Int ))
shiftDivision =
    zip
        (constant [ 5, 85, 240 ])
        (shuffle [ 2, 4, 8, 16, 32 ])


type alias ExercisesData =
    { dec2bin : List Int
    , bin2dec : List Int
    , addition : List ( Int, Int )
    , shift_multiplication : List ( Int, Int )
    , multiplication : List ( Int, Int )
    , shift_division : List ( Int, Int )
    , dec2hex : List Int
    , hex2dec : List Int
    }


exercicesData : Generator ExercisesData
exercicesData =
    map ExercisesData
        conversionNumbers
        |> andMap conversionNumbers
        |> andMap addition
        |> andMap shiftMultiplication
        |> andMap multiplication
        |> andMap shiftDivision
        |> andMap conversionNumbers
        |> andMap conversionNumbers
