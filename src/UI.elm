module UI exposing (layout)

import Gen.Route as Route exposing (Route)
import Html exposing (Html, a, div, img, nav, text, ul)
import Html.Attributes exposing (class, height, href, src, style, width)


{-| How I built the bootstrap navbar

    - Ran this code https://getbootstrap.com/docs/4.0/components/navbar/
    - Into https://html-to-elm.com/

-}
layout : List (Html msg) -> List (Html msg)
layout children =
    let
        viewLink : String -> Route -> Html msg
        viewLink label route =
            a [ class "nav-item nav-link", href (Route.toHref route) ] [ text label ]
    in
    [ nav
        [ class "navbar navbar-expand-sm", style "background-color" "#e3f2fd" ]
        [ div
            [ class "container-fluid" ]
            [ ul [ class "navbar-nav" ]
                [ a
                    [ class "navbar-brand", href (Route.toHref Route.Home_) ]
                    [ img [ src "assets/brand.png", width 30, height 30 ] [] ]
                , viewLink "Exercices binaire + hexadécimal" Route.BinaryExercises
                , viewLink "Convertisseur Unicode" Route.UnicodeConverter
                ]
            ]
        ]
    , div [ class "container pt-4" ]
        [ Html.main_ [] children ]
    ]
