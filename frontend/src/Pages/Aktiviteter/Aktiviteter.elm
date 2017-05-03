module Pages.Aktiviteter.Aktiviteter exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.List as Lists
import Material.Spinner as Loading
import Material.Typography as Typography
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , aktivitetListe : WebData (List Aktivitet)
    , appMetadata : WebData AppMetadata
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetListeResponse (WebData (List Aktivitet))
    | VisAktivitetDetalj String
    | OpprettAktivitet


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , aktivitetListe = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      }
    , Cmd.batch [ fetchAppMetadata apiEndpoint, fetchAktivitetListe apiEndpoint ]
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


fetchAktivitetListe : String -> Cmd Msg
fetchAktivitetListe endPoint =
    let
        queryUrl =
            endPoint ++ "aktiviteter"

        req =
            Http.request
                { method = "GET"
                , headers = []
                , url = queryUrl
                , body = Http.emptyBody
                , expect = Http.expectJson Decoders.decodeAktivitetListe
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> RemoteData.sendRequest
            |> Cmd.map AktivitetListeResponse


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

        -- (Debug.log "metadata-response" { model | appMetadata = response}, Cmd.none, NoSharedMsg)
        AktivitetListeResponse response ->
            ( Debug.log "aktivitet-liste-response" { model | aktivitetListe = response }, Cmd.none, NoSharedMsg )

        VisAktivitetDetalj id ->
            ( model, Cmd.none, NavigateToAktivitet id )

        OpprettAktivitet ->
            ( model, Cmd.none, NoSharedMsg )


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        [ cell
            [ size All 12
            ]
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.fab
                , Button.ripple
                , Options.onClick OpprettAktivitet
                , Options.css "float" "right"
                ]
                [ Icon.i "add" ]
            , Options.span [ Typo.display2 ] [ text "Aktiviteter" ]
            ]
        , cell
            [ size All 12
            , Elevation.e2
            ]
            [ viewMainContent model
            ]
        ]


viewMainContent : Model -> Html Msg
viewMainContent model =
    Options.div [ css "width" "100%" ]
        [ visAktivitetListe model
        ]


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


white : Options.Property a b
white =
    Color.text Color.white


visAktivitetListe : Model -> Html Msg
visAktivitetListe model =
    case model.aktivitetListe of
        NotAsked ->
            text "Venter på henting av liste.."

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            visAktivitetListeSuksess model data


visAktivitetListeSuksess : Model -> List Aktivitet -> Html Msg
visAktivitetListeSuksess model aktiviteter =
    Lists.ul [ css "width" "100%" ]
        (aktiviteter
            |> List.map (visAktivitet model)
        )


visAktivitet : Model -> Aktivitet -> Html Msg
visAktivitet model aktivitet =
    let
        selectButton model k ansattId =
            Button.render Mdl
                [ k ]
                model.mdl
                [ Button.raised
                  -- , Button.accent |> when (Set.member k model.toggles)
                  -- , Options.onClick (SelectAnsatt ansattId)
                ]
                [ text "Detaljer" ]
    in
        Lists.li [ Lists.withSubtitle ]
            -- NB! Required on every Lists.li containing subtitle.
            [ Options.div
                [ Options.center
                , Color.background (Color.color Color.Red Color.S500)
                , Color.text Color.accentContrast
                , Typography.title
                , css "width" "36px"
                , css "height" "36px"
                , css "margin-right" "2rem"
                ]
                [ text "A" ]
            , Lists.content []
                [ Options.span [] [ text <| aktivitet.navn ++ " - " ++ aktivitet.skoleNavn ++ " (" ++ (toString aktivitet.omfangTimer) ++ " skoletimer )" ]
                , Lists.subtitle [ css "width" "80%" ] [ text aktivitet.beskrivelse ]
                ]
            , Lists.content2 []
                [ Options.span [ onClick <| VisAktivitetDetalj aktivitet.id, cs "editer-aktivitet" ]
                    [ Lists.icon "mode_edit" []
                    ]
                ]
            ]
