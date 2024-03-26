module Pages.UnicodeConverter exposing (Model, Msg, page)

import Gen.Params.UnicodeConverter exposing (Params)
import Hex
import Html exposing (div, h1, input, label, text)
import Html.Attributes exposing (class, for, id, value)
import Html.Events exposing (onInput)
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


type alias Model =
    { hex : String
    , string : String
    }


init : Model
init =
    Model "" ""


type Msg
    = GotHex String
    | GotString String


update : Msg -> Model -> Model
update msg _ =
    case msg of
        GotHex hex ->
            let
                hexWithoutSpaces =
                    String.replace " " "" hex

                string =
                    if String.isEmpty hexWithoutSpaces then
                        ""

                    else
                        case Hex.fromString (String.toLower hexWithoutSpaces) of
                            Ok characterNumber ->
                                String.fromChar (Char.fromCode characterNumber)

                            Err error ->
                                error
            in
            Model hex string

        GotString string ->
            let
                hex =
                    case String.uncons string of
                        Nothing ->
                            ""

                        Just ( char, _ ) ->
                            String.toUpper (Hex.toString (Char.toCode char))
            in
            Model hex string


view : Model -> View Msg
view model =
    { title = "Convertisseur unicode"
    , body =
        UI.layout
            [ h1 [] [ text "Convertisseur unicode" ]
            , div [ class "my-3" ]
                [ label [ for "hex", class "form-label" ]
                    [ text "Numéro (hexadécimal)" ]
                , div []
                    [ input [ id "hex", value model.hex, onInput GotHex, class "form-control form-control-lg" ] [] ]
                ]
            , div [ class "my-3" ]
                [ label [ for "string", class "form-label" ]
                    [ text "Caractère" ]
                , div []
                    [ input [ id "string", value model.string, onInput GotString, class "form-control form-control-lg" ] [] ]
                ]
            ]
    }
