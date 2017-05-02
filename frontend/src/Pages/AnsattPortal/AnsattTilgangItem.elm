module Pages.AnsattPortal.AnsattTilgangItem exposing (..)
import Html exposing (Html, text, div, span, p, a)
import Material
import Json.Decode as Json exposing (field)
import Json.Encode
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import String
import Material.Table as Table
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Http exposing (Error)

type alias AnsattTilgang =
    { id : Int
    , navn : String
    , beskrivelse : String
    }

--Midlertidig navn og beskrivelse - skal kun ha tilgangs id
type alias NyAnsattTilgang =
    { navn : String
    , beskrivelse : String
    }

postNewAnsattTilgang : NyAnsattTilgang -> ((Result Error AnsattTilgang) -> msg) -> Cmd msg
postNewAnsattTilgang tilgang responseMsg =
    let
        url =
            "http://localhost:3004/ansattTilganger"

        body =
            encodeNyAnsattTilgang tilgang |> Http.jsonBody

        req =
            Http.request
                { method = "POST"
                , headers = []
                , url = url
                , body = body
                , expect = Http.expectJson decodeAnsattTilgang
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> Http.send responseMsg

encodeNyAnsattTilgang : NyAnsattTilgang -> Json.Encode.Value
encodeNyAnsattTilgang model =
    let
        encodings =
            [ ( "navn", Json.Encode.string model.navn )
            , ( "beskrivelse", Json.Encode.string model.beskrivelse )
            ]
    in
        encodings
            |> Json.Encode.object

decodeAnsattTilgangerList : Json.Decoder (List AnsattTilgang)
decodeAnsattTilgangerList =
    Json.list decodeAnsattTilgang

decodeAnsattTilgang : Json.Decoder AnsattTilgang
decodeAnsattTilgang =
    Json.map3 AnsattTilgang
        (field "id" Json.int)
        (field "navn" Json.string)
        (field "beskrivelse" Json.string)

viewAnsattTilgang : Int -> AnsattTilgang -> Material.Model -> (Material.Msg msg -> msg) -> (String -> msg) -> Html msg
viewAnsattTilgang idx model outerMdl mdlMsg selectedMsg =
    Table.tr
        []
        [ Table.td [ css "text-align" "left" ] [ text model.navn ]
        , Table.td [ css "text-align" "left" ] [ text (String.left 80 model.beskrivelse) ]
        , Table.td []
            [ Button.render mdlMsg
                [ idx ]
                outerMdl
                [ Button.minifab
                , Button.colored
                , Options.onClick (selectedMsg model.navn)
                ]
                [ Icon.view "cancel" [ Tooltip.attach mdlMsg [ idx ] ], Tooltip.render mdlMsg [ idx ] outerMdl [ Tooltip.large ] [ text "Fjern tilgang" ] ]
            ]
        ]
