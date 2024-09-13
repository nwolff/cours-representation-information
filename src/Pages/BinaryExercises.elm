module Pages.BinaryExercises exposing (Exercise, Model, Msg(..), Question, page)

import BinaryExercicesGenerators exposing (ExercisesData, exercicesData)
import Gen.Params.BinaryExercises exposing (Params)
import HexUtils exposing (bin, hex)
import Html exposing (Html, br, code, div, h1, h5, li, p, span, sub, text, ul)
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


type QuestionPart
    = B String -- Binary
    | D Int -- Decimal
    | H String -- Hexadecimal
    | S String -- String


type alias Question =
    { questionParts : List QuestionPart
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
            |> List.map (\n -> Question [ D n ] (bin 8 n))
        )
    , Exercise "2. Convertir les nombres binaires vers le décimal"
        "Utiliser la grille de conversion décimal-binaire"
        (data.bin2dec
            |> List.map (\n -> Question [ B (bin 8 n) ] (String.fromInt n))
        )
    , Exercise "3. Effectuer les additions binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.addition
            |> List.map (\( a, b ) -> Question [ B (bin 8 a), S "+", B (bin 8 b) ] (bin 8 (a + b)))
        )
    , Exercise
        "4. Convertir les nombres décimaux négatifs vers le binaire"
        "Representez leur complément à deux sur 8 bits"
        (data.dec2bin_neg
            |> List.map (\n -> Question [ D n ] (bin 8 n))
        )
    , Exercise
        "5. Convertir les nombres binaires négatifs en complément à deux vers le décimal"
        ""
        (data.bin2dec_neg
            |> List.map (\n -> Question [ B (bin 8 n) ] (String.fromInt n))
        )
    , Exercise "6. Effectuer les multiplications binaires par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_multiplication
            |> List.map (\( a, b ) -> Question [ B (bin 8 a), S "*", D b ] (bin 8 (a * b)))
        )
    , Exercise "7. Effectuer les multiplications binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.multiplication
            |> List.map (\( a, b ) -> Question [ B (bin 8 a), S "*", B (bin 8 b) ] (bin 8 (a * b)))
        )
    , Exercise "8. Effectuer les divisions binaires entières par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shift_division
            |> List.map (\( a, b ) -> Question [ B (bin 8 a), S "/", D b ] (bin 8 (a // b)))
        )
    , Exercise "9. Convertir les nombres décimaux vers l'hexadécimal"
        ""
        (data.dec2hex
            |> List.map (\n -> Question [ D n ] (hex n))
        )
    , Exercise "A. Convertir les nombres hexadécimaux vers le décimal"
        ""
        (data.hex2dec
            |> List.map (\n -> Question [ H (hex n) ] (String.fromInt n))
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
        [ span
            []
            (List.map viewQuestionPart question.questionParts)
        ]


viewQuestionPart : QuestionPart -> Html Msg
viewQuestionPart part =
    case part of
        B bin ->
            code [] [ text bin ]

        S s ->
            text (" " ++ s ++ " ")

        H hex ->
            span []
                [ text ("(" ++ hex ++ ")")
                , sub
                    []
                    [ text "16" ]
                ]

        D decimal ->
            text (String.fromInt decimal)
