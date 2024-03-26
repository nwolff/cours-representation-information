module Pages.BinaryExercises exposing (Exercise, Model, Msg(..), Question, page)

import BinaryExercicesGenerators exposing (ExercisesData, exercicesData)
import Gen.Params.BinaryExercises exposing (Params)
import HexUtils exposing (bin, hex, string)
import Html exposing (Html, br, div, h1, h5, li, p, text, ul)
import Html.Attributes exposing (attribute, class)
import Page
import Random
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
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
        (data.multiplication
            |> List.map (\( a, b ) -> Question (bin a ++ " * " ++ bin b) (bin (a * b)))
        )
    , Exercise "6. Effectuer les divisions binaires entières par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_division
            |> List.map (\( a, b ) -> Question (bin a ++ " / " ++ string b) (bin (a // b)))
        )
    , Exercise "7. Convertir les nombres décimaux vers l'hexadécimal"
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


init : ( Model, Cmd Msg )
init =
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


view : Model -> View Msg
view model =
    case model of
        Nothing ->
            { title = "Loading", body = UI.layout [] }

        Just exercises ->
            { title = "Exercices calculs binaires"
            , body =
                UI.layout
                    (List.append
                        [ h1 [] [ text "Exercices calculs binaires" ]
                        , p [] [ text "Passer le doigt ou la souris sur la ligne d'un exercice pour voir la solution" ]
                        , br [] []
                        ]
                        (List.map viewExercise exercises)
                    )
            }


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
