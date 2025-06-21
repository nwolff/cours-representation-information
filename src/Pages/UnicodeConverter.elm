module Pages.UnicodeConverter exposing (Model, Msg, page)

import Effect exposing (Effect)
import Hex
import Html exposing (div, h2, input, label, text)
import Html.Attributes exposing (class, for, id, value)
import Html.Events exposing (onInput)
import Page exposing (Page)
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



-- MODEL


type alias Model =
    { hex : String
    , string : String
    }



-- INIT


init : () -> ( Model, Effect Msg )
init () =
    ( Model "" "", Effect.none )



-- UPDATE


type Msg
    = GotHex String
    | GotString String


update : Msg -> Model -> ( Model, Effect Msg )
update msg _ =
    case msg of
        GotHex hex ->
            let
                hexWithoutSpaces : String
                hexWithoutSpaces =
                    String.replace " " "" hex

                string : String
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
            ( Model hex string, Effect.none )

        GotString string ->
            let
                hex : String
                hex =
                    case String.uncons string of
                        Nothing ->
                            ""

                        Just ( char, _ ) ->
                            String.toUpper (Hex.toString (Char.toCode char))
            in
            -- UPDATE
            ( Model hex string, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Convertisseur unicode"
    , body =
        [ h2 [] [ text "Convertir un caractère unicode" ]
        , div [ class "my-3" ]
            [ label [ for "hex", class "form-label" ]
                [ text "Numéro du caractère (en hexadécimal)" ]
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
