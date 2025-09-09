module Pages.BinaryExercises exposing (Exercise, Model, Msg(..), Part, Question, page)

import BinHexUtils exposing (bin, hex)
import BinaryExercicesGenerators exposing (ExercisesData, exercicesData)
import Effect exposing (Effect)
import Html exposing (Html, br, code, div, h1, h5, li, p, span, sub, text, ul)
import Html.Attributes exposing (class)
import Layouts
import Page exposing (Page)
import Random
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout toLayout


toLayout : Model -> Layouts.Layout Msg
toLayout _ =
    Layouts.Default {}



-- MODEL


type Part
    = S String -- String
    | D Int -- Decimal
    | B String -- Binary
    | H String -- Hexadecimal
    | N -- newline


type alias Question =
    { questionParts : List Part
    , answerParts : List Part
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
            |> List.map
                (\n ->
                    Question
                        [ D n ]
                        [ B (bin 8 n) ]
                )
        )
    , Exercise "2. Convertir les nombres binaires vers le décimal"
        "Utiliser la grille de conversion décimal-binaire"
        (data.bin2dec
            |> List.map
                (\n ->
                    Question
                        [ B (bin 8 n) ]
                        [ S (String.fromInt n) ]
                )
        )
    , Exercise "3. Effectuer les additions binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.addition
            |> List.map
                (\( a, b ) ->
                    Question
                        [ B (bin 8 a), S "+", B (bin 8 b) ]
                        [ B (bin 8 (a + b)), N, S "Vérification: ", D a, S "+", D b, S "=", D (a + b) ]
                )
        )
    , Exercise
        "4. Convertir les nombres décimaux négatifs vers le binaire"
        "Representez leur complément à deux sur 8 bits"
        (data.dec2binNeg
            |> List.map
                (\n ->
                    Question
                        [ D n ]
                        [ B (bin 8 n) ]
                )
        )
    , Exercise
        "5. Convertir les nombres binaires négatifs en complément à deux vers le décimal"
        ""
        (data.bin2decNeg
            |> List.map
                (\n ->
                    Question
                        [ B (bin 8 n) ]
                        [ D n ]
                )
        )
    , Exercise "6. Effectuer les additions binaires de nombres relatifs en complément à 2 sur 8 bits"
        "Vérifier les calculs en passant par le décimal"
        (data.additionRelative
            |> List.map
                (\( a, b ) ->
                    Question
                        [ B (bin 8 a), S "+", B (bin 8 b) ]
                        [ B (bin 8 (a + b)), N, S "Vérification: ", D a, S "+", D b, S "=", D (a + b) ]
                )
        )
    , Exercise "7. Effectuer les multiplications binaires par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shiftMultiplication
            |> List.map
                (\( a, b ) ->
                    Question
                        [ B (bin 8 a), S "*", D b ]
                        [ B (bin 8 (a * b)), N, S "Vérification: ", D a, S "*", D b, S "=", D (a * b) ]
                )
        )
    , Exercise "8. Effectuer les multiplications binaires en colonnes"
        "Vérifier les calculs en passant par le décimal"
        (data.multiplication
            |> List.map
                (\( a, b ) ->
                    Question
                        [ B (bin 8 a), S "*", B (bin 8 b) ]
                        [ B (bin 8 (a * b)), N, S "Vérification: ", D a, S "*", D b, S "=", D (a * b) ]
                )
        )
    , Exercise "9. Effectuer les divisions binaires entières par décalage de bits"
        "Vérifier les calculs en passant par le décimal"
        (data.shiftDivision
            |> List.map
                (\( a, b ) ->
                    Question
                        [ B (bin 8 a), S "/", D b ]
                        [ B (bin 8 (a // b)), N, S "Vérification: ", D a, S "/", D b, S "=", D (a // b), S "(Reste", D (modBy b a), S ")" ]
                )
        )
    , Exercise "A. Convertir les nombres décimaux vers l'hexadécimal"
        ""
        (data.dec2hex
            |> List.map
                (\n ->
                    Question
                        [ D n ]
                        [ H (hex n) ]
                )
        )
    , Exercise "B. Convertir les nombres hexadécimaux vers le décimal"
        ""
        (data.hex2dec
            |> List.map
                (\n ->
                    Question
                        [ H (hex n) ]
                        [ D n ]
                )
        )
    ]


generateExercisesData : Effect Msg
generateExercisesData =
    Effect.sendCmd (Random.generate GotExercisesData exercicesData)



-- INIT


init : () -> ( Model, Effect Msg )
init () =
    ( Nothing, generateExercisesData )



-- UPDATE


type Msg
    = GotExercisesData ExercisesData


update : Msg -> Model -> ( Model, Effect Msg )
update msg _ =
    case msg of
        GotExercisesData exercisesData ->
            ( Just (exercicesFromData exercisesData), Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    case model of
        Nothing ->
            { title = "Loading", body = [] }

        Just exercises ->
            { title = "Exercices binaire et hexa"
            , body =
                List.append
                    [ h1 [] [ text "Exercices binaire et hexa" ]
                    , p [] [ text "Passer le doigt ou la souris sur une question pour voir la solution" ]
                    , br [] []
                    ]
                    (List.map viewExercise exercises)
            }


viewExercise : Exercise -> Html Msg
viewExercise exercise =
    div [ class "exercise" ]
        [ h5 [] [ text exercise.title ]
        , p [] [ text exercise.description ]
        , ul [ class "list-group list-group-flush w-50" ]
            (List.map viewQuestion exercise.questions)
        , br [] []
        ]


viewQuestion : Question -> Html Msg
viewQuestion question =
    li
        [ class "list-group-item" ]
        [ div []
            [ div [ class "question" ]
                (List.map viewPart question.questionParts)
            , div [ class "answer" ]
                (List.map viewPart question.answerParts)
            ]
        ]


viewPart : Part -> Html Msg
viewPart part =
    case part of
        S s ->
            text (" " ++ s ++ " ")

        D decimal ->
            text (String.fromInt decimal)

        B bin ->
            code [] [ text bin ]

        H hex ->
            span []
                [ text ("(" ++ hex ++ ")")
                , sub
                    []
                    [ text "16" ]
                ]

        N ->
            text "\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}"
