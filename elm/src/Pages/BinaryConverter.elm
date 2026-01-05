module Pages.BinaryConverter exposing (Model, Msg, page)

import BinHexUtils
import Effect
import Html exposing (br, div, h2, input, label, p, sup, text)
import Html.Attributes exposing (class, for, id, value)
import Html.Events exposing (onInput)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = \() -> ( init, Effect.none )
        , update = \msg model -> ( update msg model, Effect.none )
        , view = view
        , subscriptions = \_ -> Sub.none
        }
        |> Page.withLayout toLayout


toLayout : Model -> Layouts.Layout Msg
toLayout _ =
    Layouts.Default {}



-- MODEL


type alias Model =
    { bin : String
    , dec : String
    , hex : String
    }



-- INIT


init : Model
init =
    Model "" "" ""



-- UPDATE


type Source
    = Bin
    | Dec
    | Hex


type Msg
    = Got Source String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Got source s ->
            if String.isEmpty s then
                Model "" "" ""

            else
                let
                    maybeDecoded =
                        case source of
                            Bin ->
                                BinHexUtils.parseBinaryString s

                            Dec ->
                                BinHexUtils.parseDecimalString s

                            Hex ->
                                BinHexUtils.parseHexString s
                in
                case maybeDecoded of
                    Nothing ->
                        model

                    Just number ->
                        Model (BinHexUtils.bin number) (String.fromInt number) (BinHexUtils.hex number)



-- VIEW


view : Model -> View Msg
view model =
    { title = "Convertisseur binaire-décimal-hexadécimal"
    , body =
        [ h2 [] [ text "Convertir des nombres" ]
        , p [] [ text "Fonctionne pour les nombres positifs jusqu'à 2", sup [] [ text "32" ], text " - 1" ]
        , br [] []
        , div [ class "my-3" ]
            [ label [ for "bin", class "form-label" ]
                [ text "Binaire" ]
            , div []
                [ input [ id "bin", value model.bin, onInput (Got Bin), class "form-control form-control-lg" ] [] ]
            ]
        , div [ class "my-3" ]
            [ label [ for "dec", class "form-label" ]
                [ text "Décimal" ]
            , div []
                [ input [ id "dec", value model.dec, onInput (Got Dec), class "form-control form-control-lg" ] [] ]
            ]
        , div [ class "my-3" ]
            [ label [ for "hex", class "form-label" ]
                [ text "Hexadécimal" ]
            , div []
                [ input [ id "hex", value model.hex, onInput (Got Hex), class "form-control form-control-lg" ] [] ]
            ]
        ]
    }
