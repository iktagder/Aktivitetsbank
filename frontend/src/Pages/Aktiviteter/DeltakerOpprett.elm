module Pages.Aktiviteter.DeltakerOpprett exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Typography as Typography
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Dropdown
import Json.Decode


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , appMetadata : WebData AppMetadata
    -- , valgtSkole : Maybe Skole
    , deltaker : Deltaker
    -- , dropdownStateSkole : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    -- | OnSelectSkole (Maybe Skole)
    -- | SkoleDropdown (Dropdown.Msg Skole)
    -- | OnSelectAktivitetstype (Maybe AktivitetsType)
    -- | AktivitetstypeDropdown (Dropdown.Msg AktivitetsType)
    -- | EndretAktivitetsNavn String
    -- | EndretAktivitetsBeskrivelse String
    -- | EndretAktivitetsOmfangTimer String
    -- | OpprettNyAktivitet
    -- | NyAktivitetRespons (Result Error NyAktivitet)

init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , appMetadata = RemoteData.NotAsked
      -- , valgtSkole = Nothing
      -- , dropdownStateSkole = Dropdown.newState "1"
      -- , valgtAktivitetstype = Nothing
      -- , dropdownStateAktivitetstype = Dropdown.newState "1"
      , deltaker =
            { id = "0"
            , aktivitetId = "0"
            , aktivitetNavn = ""
            , utdanningsprogramId = "0"
            , utdanningsprogramNavn = ""
            , trinnId = "0"
            , trinnNavn = ""
            , fagId = "0"
            , fagNavn = ""
            , timer = 0
            , kompetansemaal = ""
            }
      }
    , Cmd.none
    )


fetchAppMetadata : String -> Cmd Msg
fetchAppMetadata endPoint =
    let
        queryUrl =
            endPoint ++ "AktivitetsbankMetadata"

        req =
            Http.request
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
                ( model_, cmd_ ) =
                    Material.update Mdl msg_ model
            in
                ( model_, cmd_, NoSharedMsg )

        AppMetadataResponse response ->
            ( { model | appMetadata = response }, Cmd.none, NoSharedMsg )

showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


vis : Taco -> Model -> Html Msg
vis taco model =
    grid []
        [ cell
            [ size All 12
            , Elevation.e0
            , Options.css "align-items" "top"
            , Options.cs "mdl-grid"
            ]
            [ Options.styled p [ Typo.display2 ] [ text "Opprett deltaker" ]
            ]
        , cell
            [ size All 12
            , Elevation.e2
            , Options.css "padding" "16px 32px"
            , Options.css "display" "flex"
              -- , Options.css "flex-direction" "column"
              -- , Options.css "align-items" "left"
            ]
            [
            -- [ visOpprettDeltaker model model.deltaker
            ]
        ]