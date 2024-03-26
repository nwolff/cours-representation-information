module Pages.Home_ exposing (view)

import Html exposing (div, h1, text)
import Html.Attributes exposing (class)
import UI
import View exposing (View)


view : View msg
view =
    { title = "Accueil"
    , body =
        UI.layout
            [ h1 [] [ text "Représentation de l'information" ]
            , div [ class "my-3" ]
                [ text "Utilisez le menu au dessus pour choisir une activité" ]
            ]
    }
