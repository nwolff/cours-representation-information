module Pages.Home_ exposing (page)

import Html exposing (div, h1, text)
import Html.Attributes exposing (class)
import View exposing (View)


page : View msg
page =
    { title = "Accueil"
    , body =
        [ h1 [] [ text "Représentation de l'information" ]
        , div [ class "my-3" ]
            [ text "Utilisez le menu au dessus pour choisir une activité" ]
        ]
    }
