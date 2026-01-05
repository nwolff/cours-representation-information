module Layouts.Default exposing (Model, Msg, Props, layout)

import Effect exposing (Effect)
import Html exposing (Html, a, div, img, nav, text, ul)
import Html.Attributes exposing (class, height, href, src, style, width)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout _ _ _ =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


{-| How I built the bootstrap navbar

    - Ran this code https://getbootstrap.com/docs/4.0/components/navbar/
    - Into https://html-to-elm.com/

-}
view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    let
        viewLink : String -> String -> Html msg
        viewLink label route =
            a [ class "nav-item nav-link mx-2", href route ] [ text label ]
    in
    { title = content.title
    , body =
        [ nav
            [ class "navbar navbar-dark bg-dark navbar-expand-sm" ]
            [ div
                [ class "container-fluid" ]
                [ ul [ class "navbar-nav" ]
                    [ a
                        [ class "navbar-brand", href "/" ]
                        [ img [ src "assets/brand.png", width 30, height 30 ] [] ]
                    , viewLink "Exercices binaire et hexadécimal" "binary-exercises"
                    , viewLink "bin-dec-hex" "binary-converter"
                    , viewLink "Unicode" "unicode-converter"
                    , viewLink "RVB" "r-g-b-slider"
                    ]
                ]
            ]
        , div [ class "container pt-4" ]
            [ Html.main_ [] content.body ]
        ]
    }
