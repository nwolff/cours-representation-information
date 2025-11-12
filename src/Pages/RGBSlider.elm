module Pages.RGBSlider exposing (Model, Msg, page)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class, style, type_, value)
import Html.Events exposing (onInput)
import Maybe exposing (withDefault)
import Page exposing (Page)
import View exposing (View)


page : Page Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { red : Int
    , green : Int
    , blue : Int
    }



-- INIT


init : Model
init =
    { red = 0
    , green = 0
    , blue = 0
    }



-- UPDATE


type Msg
    = RedChanged Int
    | GreenChanged Int
    | BlueChanged Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        RedChanged newRed ->
            { model | red = newRed }

        GreenChanged newGreen ->
            { model | green = newGreen }

        BlueChanged newBlue ->
            { model | blue = newBlue }



-- VIEW


view : Model -> View Msg
view model =
    { title = "Synthèse additive RVB"
    , body =
        [ div
            [ style "background-color" "black"
            , style "width" "100%"
            , style "height" "100vh"
            , style "display" "flex"
            , style "flex-direction" "row"
            , style "align-items" "center"
            , style "gap" "50px"
            ]
            [ div
                [ style "display" "flex"
                , style "flex-direction" "column"
                , style "gap" "30px"
                , style "padding-left" "30px"
                , style "padding-right" "30px"
                , style "padding-top" "20px"
                , style "border-radius" "8px"
                , style "box-shadow" "0 4px 8px rgba(0,0,0,0.1)"
                , style "color" "white"
                ]
                [ slider "Rouge" "red" model.red RedChanged
                , slider "Vert" "green" model.green GreenChanged
                , slider "Bleu" "blue" model.blue BlueChanged
                ]
            , div
                [ style "position" "relative"
                , style "width" "min(95vw,95vh)"
                , style "height" "min(95vw,95vh)"
                , style "align" "center"
                ]
                [ circle 40 40 (rgbColor model.red 0 0)
                , circle 60 40 (rgbColor 0 model.green 0)
                , circle 50 60 (rgbColor 0 0 model.blue)
                ]
            ]
        ]
    }


slider : String -> String -> Int -> (Int -> Msg) -> Html Msg
slider label accentColor currentValue msgConstructor =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "padding-left" "50px"
        , style "gap" "8px"
        ]
        [ Html.label [] [ text (label ++ " : " ++ String.fromInt currentValue) ]
        , input
            [ type_ "range"
            , class "color-slider"
            , style "accent-color" accentColor
            , Html.Attributes.min "0"
            , Html.Attributes.max "255"
            , value (String.fromInt currentValue)
            , onInput (msgConstructor << withDefault 0 << String.toInt)
            ]
            []
        ]


circle : Int -> Int -> String -> Html msg
circle left top rgb =
    div
        [ style "position" "absolute"
        , style "border-radius" "50%"
        , style "mix-blend-mode" "screen"
        , style "background-color" rgb
        , style "width" "min(55vw,55vh)"
        , style "height" "min(55vw,55vh)"
        , style "border-color" "white"
        , style "border-style" "dotted"
        , style "left" (String.fromInt left ++ "%")
        , style "top" (String.fromInt top ++ "%")
        , style "transform" "translate(-50%, -50%)"
        ]
        []



-- HELPERS


rgbColor : Int -> Int -> Int -> String
rgbColor r g b =
    "rgb(" ++ String.fromInt r ++ ", " ++ String.fromInt g ++ ", " ++ String.fromInt b ++ ")"
