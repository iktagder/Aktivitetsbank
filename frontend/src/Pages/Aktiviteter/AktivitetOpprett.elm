module Pages.Aktiviteter.AktivitetOpprett exposing (..)

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
    , valgtSkole : Maybe Skole
    , aktivitet : Aktivitet
    , dropdownStateSkole : Dropdown.State
    , valgtAktivitetstype : Maybe AktivitetsType
    , dropdownStateAktivitetstype : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    | OnSelectSkole (Maybe Skole)
    | SkoleDropdown (Dropdown.Msg Skole)
    | OnSelectAktivitetstype (Maybe AktivitetsType)
    | AktivitetstypeDropdown (Dropdown.Msg AktivitetsType)
    | EndretAktivitetsNavn String
    | EndretAktivitetsBeskrivelse String
    | EndretAktivitetsOmfangTimer String
    | OpprettNyAktivitet
    | NyAktivitetRespons (Result Error NyAktivitet)


dropdownConfigSkole : Dropdown.Config Msg Skole
dropdownConfigSkole =
    Dropdown.newConfig OnSelectSkole .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg skole"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"


dropdownConfigAktivitetstype : Dropdown.Config Msg AktivitetsType
dropdownConfigAktivitetstype =
    Dropdown.newConfig OnSelectAktivitetstype .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg aktivitetstype"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , appMetadata = RemoteData.NotAsked
      , valgtSkole = Nothing
      , dropdownStateSkole = Dropdown.newState "1"
      , valgtAktivitetstype = Nothing
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      , aktivitet =
            { id = "00000-0000-00000"
            , navn = ""
            , beskrivelse = ""
            , omfangTimer = 0
            , skoleId = "1"
            , skoleNavn = ""
            , aktivitetsTypeId = ""
            , aktivitetsTypeNavn = ""
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


postOpprettNyAktivitet : String -> Aktivitet -> (Result Error NyAktivitet -> msg) -> Cmd msg
postOpprettNyAktivitet endPoint aktivitet responseMsg =
    let
        url =
            endPoint ++ "aktiviteter/opprettAktivitet"

        body =
            encodeOpprettNyAktivitet aktivitet |> Http.jsonBody

        req =
            Http.request
                { method = "POST"
                , headers = []
                , url = url
                , body = body
                , expect = Http.expectJson decodeNyAktivitet
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> Http.send responseMsg


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

        OnSelectSkole skole ->
            let
                gammelAktivitet =
                    model.aktivitet

                nySkoleId =
                    case skole of
                        Just data ->
                            data.id

                        Nothing ->
                            "00"

                oppdatertAktivitet =
                    { gammelAktivitet | skoleId = nySkoleId }
            in
                ( { model | valgtSkole = skole, aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        SkoleDropdown skole ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigSkole skole model.dropdownStateSkole
            in
                ( { model | dropdownStateSkole = updated }, cmd, NoSharedMsg )

        OnSelectAktivitetstype aktivitetstype ->
            let
                gammelAktivitet =
                    model.aktivitet

                nyAktivitetId =
                    case aktivitetstype of
                        Just data ->
                            data.id

                        Nothing ->
                            "00"

                oppdatertAktivitet =
                    { gammelAktivitet | aktivitetsTypeId = nyAktivitetId }
            in
                ( { model | valgtAktivitetstype = aktivitetstype, aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        AktivitetstypeDropdown aktivitetstype ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigAktivitetstype aktivitetstype model.dropdownStateAktivitetstype
            in
                ( { model | dropdownStateAktivitetstype = updated }, cmd, NoSharedMsg )

        EndretAktivitetsNavn endretNavn ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | navn = endretNavn }
            in
                ( Debug.log "endretNavn:" { model | aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        EndretAktivitetsBeskrivelse endretBeskrivelse ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | beskrivelse = endretBeskrivelse }
            in
                ( { model | aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        EndretAktivitetsOmfangTimer endretOmfangTimer ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | omfangTimer = Result.withDefault 0 (String.toInt endretOmfangTimer) }
            in
                ( { model | aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        OpprettNyAktivitet ->
            ( model, postOpprettNyAktivitet model.apiEndpoint model.aktivitet NyAktivitetRespons, NoSharedMsg )

        NyAktivitetRespons (Ok nyId) ->
            let
                tmp =
                    Debug.log "ny aktivitet" nyId
            in
                ( model, Cmd.none, NoSharedMsg )

        NyAktivitetRespons (Err error) ->
            let
                tmp =
                    Debug.log "ny aktivitet - error" error
            in
                ( model, Cmd.none, NoSharedMsg )


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        [ cell
            [ size All 12
            , Elevation.e0
            , Options.css "align-items" "top"
            , Options.cs "mdl-grid"
            ]
            [ Options.styled p [ Typo.display2 ] [ text "Opprett aktivitet" ]
            ]
        , cell
            [ size All 12
            , Elevation.e2
            , Options.css "padding" "16px 32px"
            , Options.css "display" "flex"
              -- , Options.css "flex-direction" "column"
              -- , Options.css "align-items" "left"
            ]
            [ opprettAktivitet model model.aktivitet
            ]
        ]


visSkole : Model -> Html Msg
visSkole model =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visSkoleDropdown
                model.valgtSkole
                data.skoler
                model.dropdownStateSkole


visSkoleDropdown : Maybe Skole -> List Skole -> Dropdown.State -> Html Msg
visSkoleDropdown selectedSkoleId model dropdownStateSkole =
    span []
        [ Html.map SkoleDropdown (Dropdown.view dropdownConfigSkole dropdownStateSkole model selectedSkoleId)
        ]


visAktivitetstype : Model -> Html Msg
visAktivitetstype model =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visAktivitetstypeDropdown
                model.valgtAktivitetstype
                data.aktivitetstyper
                model.dropdownStateAktivitetstype


visAktivitetstypeDropdown : Maybe AktivitetsType -> List AktivitetsType -> Dropdown.State -> Html Msg
visAktivitetstypeDropdown selectedAktivitetstypeId model dropdownStateAktivitetstype =
    span []
        [ Html.map AktivitetstypeDropdown (Dropdown.view dropdownConfigAktivitetstype dropdownStateAktivitetstype model selectedAktivitetstypeId)
        ]


opprettAktivitet : Model -> Aktivitet -> Html Msg
opprettAktivitet model aktivitet =
    Options.div
        []
        [ Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Navn"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value <| aktivitet.navn
            , Options.onInput EndretAktivitetsNavn
            ]
            []
        , Textfield.render Mdl
            [ 2 ]
            model.mdl
            [ Textfield.label "Beskrivelse"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.textarea
            , Textfield.rows 6
            , Textfield.value <| aktivitet.beskrivelse
            , Options.onInput EndretAktivitetsBeskrivelse
            , cs "text-area"
            ]
            []
        , Textfield.render Mdl
            [ 3 ]
            model.mdl
            [ Textfield.label "Omfang"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value <| toString aktivitet.omfangTimer
            , Options.onInput EndretAktivitetsOmfangTimer
            ]
            []
        , showText p Typo.menu "Skole"
        , visSkole model
        , showText p Typo.menu "Aktivitetstype"
        , visAktivitetstype model
        , Button.render Mdl
            [ 10, 1 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.onClick (OpprettNyAktivitet)
            , css "float" "right"
              -- , css "margin-left" "1em"
              -- , Options.onClick (SearchAnsatt "Test")
            ]
            [ text "Lagre" ]
        ]
