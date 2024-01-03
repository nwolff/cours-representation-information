module Main exposing (Exercise, Model, Msg(..), Question, main)

import Binary exposing (fromDecimal, toHex, toIntegers)
import Browser exposing (Document)
import Chunk exposing (chunk)
import Generators exposing (ExercisesData, exercicesData)
import Html exposing (Html, br, div, h1, h5, li, p, text, ul)
import Html.Attributes exposing (attribute, class)
import Random


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Question =
    { question : String
    , answer : String
    }


type alias Exercise =
    { title : String
    , description : String
    , questions : List Question
    }


type alias Model =
    Maybe (List Exercise)


bin : Int -> String
bin n =
    n |> fromDecimal |> toIntegers |> List.map String.fromInt |> String.concat |> chunk 4 "'"


hex : Int -> String
hex n =
    n |> fromDecimal |> toHex


string : Int -> String
string n =
    String.fromInt n


exercicesFromData : ExercisesData -> List Exercise
exercicesFromData data =
    [ Exercise
        "1. Convertir les nombres décimaux vers le binaire"
        "Utiliser la grille de conversion décimal-binaire"
        (data.dec2bin
            |> List.map (\n -> Question (string n) (bin n))
        )
    , Exercise "2. Convertir les nombres binaires vers le décimal"
        "Utiliser la grille de conversion décimal-binaire"
        (data.bin2dec
            |> List.map (\n -> Question (bin n) (string n))
        )
    , Exercise "3. Effectuer les additions binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.addition
            |> List.map (\( a, b ) -> Question (bin a ++ " + " ++ bin b) (bin (a + b)))
        )
    , Exercise "4. Effectuer les multiplications binaires par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_multiplication
            |> List.map (\( a, b ) -> Question (bin a ++ " * " ++ string b) (bin (a * b)))
        )
    , Exercise "5. Effectuer les multiplications binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_multiplication
            |> List.map (\( a, b ) -> Question (bin a ++ " * " ++ bin b) (bin (a * b)))
        )
    , Exercise "6. Effectuer les divisions binaires entières par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_division
            |> List.map (\( a, b ) -> Question (bin a ++ " / " ++ string b) (bin (a // b)))
        )
    , Exercise "7. Convertir les nombres décimaux vers le binaire"
        ""
        (data.dec2hex
            |> List.map (\n -> Question (string n) (hex n))
        )
    , Exercise "8. Convertir les nombres hexadécimaux vers le décimal"
        ""
        (data.hex2dec
            |> List.map (\n -> Question (hex n) (string n))
        )
    ]


generateExercisesData : Cmd Msg
generateExercisesData =
    Random.generate GotExercisesData exercicesData


init : () -> ( Model, Cmd Msg )
init _ =
    ( Nothing, generateExercisesData )


type Msg
    = GotExercisesData ExercisesData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotExercisesData exercisesData ->
            ( Just (exercicesFromData exercisesData), Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    case model of
        Nothing ->
            Document "Loading" []

        Just exercises ->
            Document "Exercices calculs binaires"
                [ div [ class "container pt-4" ]
                    (List.append
                        [ h1 [] [ text "Exercices représentation de l'information" ]
                        , p [] [ text "Passer le doigt ou la souris sur la ligne d'un exercice pour voir la solution" ]
                        , br [] []
                        ]
                        (List.map viewExercise exercises)
                    )
                ]


viewExercise : Exercise -> Html Msg
viewExercise exercise =
    div []
        [ h5 [] [ text exercise.title ]
        , text exercise.description
        , br [] []
        , ul [ class "list-group list-group-flush w-50 offset-1" ]
            (List.map viewQuestion exercise.questions)
        , br [] []
        ]


viewQuestion : Question -> Html Msg
viewQuestion question =
    li
        [ class "list-group-item text-end"
        , attribute "tooltip" question.answer
        , attribute "tooltip-position" "right"
        ]
        [ text question.question ]
