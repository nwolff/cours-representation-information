module Pages.RGBSlider exposing (Model, Msg, page)

import Css exposing (..)
import Gen.Params.UnicodeConverter exposing (Params)
import Html.Styled exposing (Html, div, input, label, text)
import Html.Styled.Attributes exposing (attribute, css, style, value)
import Html.Styled.Events exposing (onInput)
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
                [ css
                    [ backgroundColor (hex "0")
                    , width (pc 100)
                    , height (vh 100)
                    ]
                ]
                [ div
                    [ css
                        [ displayFlex
                        , justifyContent center
                        , marginTop (px 20)
                        ]
                    , style "gap" "20px"
                    ]
                    [ slider "Rouge" model.red RedChanged
                    , slider "Vert" model.green GreenChanged
                    , slider "Bleu" model.blue BlueChanged
                    ]
                , div
                    [ css
                        [ position relative
                        , width (px 600)
                        , height (px 600)
                        ]
                    ]
                    [ div
                        [ css
                            [ position absolute
                            , width (px 400)
                            , height (px 400)
                            , borderRadius (pct 50)
                            , backgroundColor (rgb model.red 0 0)
                            , left (px 100)
                            , top (px 100)
                            ]
                        , style "mix-blend-mode" "screen"
                        ]
                        []
                    ]
                ]
            ]
    }


slider : String -> Int -> (Int -> Msg) -> Html Msg
slider label currentValue msgConstructor =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , alignItems center
            ]
        ]
        [ input
            [ attribute "type" "range"
            , Html.Styled.Attributes.min "0"
            , Html.Styled.Attributes.max "255"
            , value (String.fromInt currentValue)
            , onInput (msgConstructor << withDefault 0 << String.toInt)
            ]
            []
        , Html.Styled.label [] [ text label ]
        ]



-- HELPERS


rgbColor : Int -> Int -> Int -> String
rgbColor r g b =
    "rgb(" ++ String.fromInt r ++ ", " ++ String.fromInt g ++ ", " ++ String.fromInt b ++ ")"
