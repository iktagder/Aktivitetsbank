module Pages.Aktiviteter.Aktiviteter exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Textfield as Textfield
import Material.List as Lists
import Material.Spinner as Loading
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    -- , searchAnsattResponse : WebData (List AnsattSearchItem)
    , appMetadata : WebData AppMetadata
    }



type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      -- , searchAnsattResponse = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      }
    , fetchAppMetadata apiEndpoint
    )

fetchAppMetadata : String -> Cmd Msg
fetchAppMetadata endPoint =
    let
      queryUrl =
        endPoint ++ "AktivitetsbankMetadata"
      req =  Http.request
        { method = "GET"
        , headers = []
        , url = queryUrl
        , body = Http.emptyBody
        , expect = Http.expectJson Decoders.decodeAppMetadata
        , timeout = Nothing
        , withCredentials = True
        }
    in
        req
        |> RemoteData.sendRequest
        |> Cmd.map AppMetadataResponse



update : Msg -> Model -> ( Model, Cmd Msg, SharedMsg )
update msg model =
    case msg of
        Mdl msg_ ->
          let
            (model_, cmd_ ) =
              Material.update Mdl msg_ model
          in
            (model_, cmd_, NoSharedMsg)
        AppMetadataResponse response ->
            ({ model | appMetadata = response}, Cmd.none, NoSharedMsg)
            -- (Debug.log "metadata-response" { model | appMetadata = response}, Cmd.none, NoSharedMsg)



view : Taco -> Model -> Html Msg
view taco model =
        grid [ Options.css "max-width" "1280px" ]
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "align-items" "top"
                , Options.cs "mdl-grid"
                ]
                [ Options.styled p [ Typo.display2 ] [ text "Aktiviteter" ]
                ]
            , cell
                [ size All 12
                , Elevation.e2
                , Options.css "padding" "16px 32px"
                , Options.css "display" "flex"
                , Options.css "flex-direction" "column"
                , Options.css "align-items" "left"
                ]
                [ viewMainContent model
                ]
            ]

viewMainContent : Model -> Html Msg
viewMainContent model =
          div [][ text "main content"
                ]
showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


white : Options.Property a b
white =
    Color.text Color.white
