module Pages.RGBSlider exposing (Model, Msg, page)

import Gen.Params.UnicodeConverter exposing (Params)
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (attribute, style, value)
import Html.Events exposing (onInput)
import Maybe exposing (withDefault)
import Page
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
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
    { title = "RGB Slider"
    , body =
        UI.layout
            [ div
                [ style "background-color" "black"
                , style "width" "100%"
                , style "height" "100vh"
                ]
                [ div
                    [ style "display" "flex"
                    , style "justify-content" "center"
                    , style "gap" "20px"
                    , style "margin-top" "20px"
                    ]
                    [ slider "Rouge" model.red RedChanged
                    , slider "Vert" model.green GreenChanged
                    , slider "Bleu" model.blue BlueChanged
                    ]
                , div
                    [ style "position" "relative"
                    , style "width" "600px"
                    , style "height" "600px"
                    ]
                    [ div
                        [ style "position" "absolute"
                        , style "width" "400px"
                        , style "height" "400px"
                        , style "border-radius" "50%"
                        , style "mix-blend-mode" "screen"
                        , style "background-color" (rgbColor model.red 0 0)
                        , style "left" "100px"
                        , style "top" "100px"
                        ]
                        []
                    , div
                        [ style "position" "absolute"
                        , style "width" "400px"
                        , style "height" "400px"
                        , style "border-radius" "50%"
                        , style "mix-blend-mode" "screen"
                        , style "background-color" (rgbColor 0 model.green 0)
                        , style "left" "300px"
                        , style "top" "100px"
                        ]
                        []
                    , div
                        [ style "position" "absolute"
                        , style "width" "400px"
                        , style "height" "400px"
                        , style "border-radius" "50%"
                        , style "mix-blend-mode" "screen"
                        , style "background-color" (rgbColor 0 0 model.blue)
                        , style "left" "200px"
                        , style "top" "300px"
                        ]
                        []
                    ]
                ]
            ]
    }


slider : String -> Int -> (Int -> Msg) -> Html Msg
slider label currentValue msgConstructor =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        ]
        [ input
            [ attribute "type" "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "255"
            , value (String.fromInt currentValue)
            , onInput (msgConstructor << withDefault 0 << String.toInt)
            ]
            []
        , Html.label [] [ text label ]
        ]



-- HELPERS


rgbColor : Int -> Int -> Int -> String
rgbColor r g b =
    "rgb(" ++ String.fromInt r ++ ", " ++ String.fromInt g ++ ", " ++ String.fromInt b ++ ")"
