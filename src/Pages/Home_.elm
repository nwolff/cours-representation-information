module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (div, h1, text)
import Html.Attributes exposing (class)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = \() -> ( {}, Effect.none )
        , update = \_ model -> ( model, Effect.none )
        , view = view
        , subscriptions = \_ -> Sub.none
        }
        |> Page.withLayout toLayout


toLayout : Model -> Layouts.Layout Msg
toLayout _ =
    Layouts.Default {}



-- MODEL


type alias Model =
    {}


type Msg
    = ReplaceMe


view : Model -> View msg
view _ =
    { title = "Accueil"
    , body =
        [ h1 [] [ text "Représentation de l'information" ]
        , div [ class "my-3" ]
            [ text "Utilisez le menu au dessus pour choisir une activité" ]
        ]
    }
