module Pages.Aktiviteter.Aktivitet exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Textfield as Textfield
import Material.List as Lists
import Material.Button as Button
import Material.Color as Color
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Spinner as Loading
import Material.Typography as Typography
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Dropdown


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , aktivitet : WebData Aktivitet
    , deltakere : WebData (List Deltaker)
    , appMetadata : WebData AppMetadata
    , valgtSkole : Maybe Skole
    , dropdownStateSkole : Dropdown.State
    , valgtAktivitetstype : Maybe AktivitetsType
    , dropdownStateAktivitetstype : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | VisAktivitetDeltakerDetalj String
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetResponse (WebData Aktivitet)
    | AktivitetDeltakereResponse (WebData (List Deltaker))
    | OnSelectSkole (Maybe Skole)
    | SkoleDropdown (Dropdown.Msg Skole)
    | OnSelectAktivitetstype (Maybe AktivitetsType)
    | AktivitetstypeDropdown (Dropdown.Msg AktivitetsType)


dropdownConfigSkole : Dropdown.Config Msg Skole
dropdownConfigSkole =
    Dropdown.newConfig OnSelectSkole .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray"
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
        |> Dropdown.withMenuClass "border border-gray"
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
      , aktivitet = RemoteData.NotAsked
      , deltakere = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      , valgtSkole = Nothing
      , dropdownStateSkole = Dropdown.newState "1"
      , valgtAktivitetstype = Nothing
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      }
    , Cmd.none
    )


hentAktivitetDetalj : String -> String -> Cmd Msg
hentAktivitetDetalj id endPoint =
    let
        queryUrl =
            endPoint ++ "aktiviteter/" ++ id

        req =
            Http.request
                { method = "GET"
                , headers = []
                , url = queryUrl
                , body = Http.emptyBody
                , expect = Http.expectJson Decoders.decodeAktivitet
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> RemoteData.sendRequest
            |> Cmd.map AktivitetResponse

hentAktivitetDeltakere : String -> String -> Cmd Msg
hentAktivitetDeltakere id endPoint =
    let
        queryUrl =
            endPoint ++ "aktiviteter/" ++ id ++ "/deltakere"

        req =
            Http.request
                { method = "GET"
                , headers = []
                , url = queryUrl
                , body = Http.emptyBody
                , expect = Http.expectJson Decoders.decodeDeltakerListe
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> RemoteData.sendRequest
            |> Cmd.map AktivitetDeltakereResponse

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

        VisAktivitetDeltakerDetalj id ->
            ( model, Cmd.none, NoSharedMsg )

        AktivitetDeltakereResponse response ->
            ( { model |  deltakere = Debug.log "Deltakere:" response }, Cmd.none, NoSharedMsg )

        AktivitetResponse response ->
            let
              (valgtSkole, valgtAktivitetstype) =
                case response of
                  Success aktivitet ->
                    (Just {id = aktivitet.skoleId, navn = aktivitet.skoleNavn, kode = ""}, Just {id = aktivitet.aktivitetsTypeId, navn = aktivitet.aktivitetsTypeNavn})
                  _ ->
                    (Nothing, Nothing)
            in

            ( Debug.log "aktivitet-item-response" { model | aktivitet = response, valgtSkole = valgtSkole, valgtAktivitetstype = valgtAktivitetstype }, Cmd.none, NoSharedMsg )

        OnSelectSkole skole ->
            ( { model | valgtSkole = skole }, Cmd.none, NoSharedMsg )

        SkoleDropdown skole ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigSkole skole model.dropdownStateSkole
            in
                ( { model | dropdownStateSkole = updated }, cmd, NoSharedMsg )

        OnSelectAktivitetstype aktivitetstype ->
            ( { model | valgtAktivitetstype = aktivitetstype }, Cmd.none, NoSharedMsg )

        AktivitetstypeDropdown aktivitetstype ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigAktivitetstype aktivitetstype model.dropdownStateAktivitetstype
            in
                ( { model | dropdownStateAktivitetstype = updated }, cmd, NoSharedMsg )

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
            [ Options.styled p [ Typo.display2 ] [ text "Aktivitet" ]
            ]
        , cell
            [ size All 12
            , Elevation.e2
            , Options.css "padding" "16px 32px"
            , Options.css "display" "flex"
              -- , Options.css "flex-direction" "column"
              -- , Options.css "align-items" "left"
            ]
            [ visAktivitet model
            ]
        , cell
            [ size All 12
            , Elevation.e2
            , Options.css "padding" "16px 32px"
            , Options.css "display" "flex"
              -- , Options.css "flex-direction" "column"
              -- , Options.css "align-items" "left"
            ]
            [ visAktivitetDeltakere model
            ]
        ]


visAktivitet : Model -> Html Msg
visAktivitet model =
    case model.aktivitet of
        NotAsked ->
            text "Venter på henting av .."

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            visAktivitetSuksess model data


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

visAktivitetSuksess : Model -> Aktivitet -> Html Msg
visAktivitetSuksess model aktivitet =
    Options.div
        [ css "width" "100%"
        ]
        [ Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Navn"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value <| aktivitet.navn
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
            ]
            []
        , showText p Typo.menu "Skole"
        , visSkole model
        , showText p Typo.menu "Aktivitetstype"
        , visAktivitetstype model
        ]

visAktivitetDeltakere : Model -> Html Msg
visAktivitetDeltakere model =
    case model.deltakere of
        NotAsked ->
            text "Venter på henting av deltakere.."

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            visAktivitetDeltakereSuksess model data

visAktivitetDeltakereSuksess : Model -> List Deltaker -> Html Msg
visAktivitetDeltakereSuksess model deltakere =
    Lists.ul [ css "width" "100%" ]
        (deltakere
            |> List.map (visAktivitetDeltaker model)
        )

visAktivitetDeltaker : Model -> Deltaker -> Html Msg
visAktivitetDeltaker model deltaker =
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
                [ text <| String.left 1 deltaker.utdanningsprogramNavn ]
            , Lists.content []
                [ Options.span [] [ text <| deltaker.aktivitetNavn ++ " - " ++ deltaker.trinnNavn ++ " - " ++ deltaker.fagNavn ++  " (" ++ (toString deltaker.timer) ++ " skoletimer )" ]
                , Lists.subtitle [ css "width" "80%" ] [ text deltaker.kompetansemaal ]
                ]
            , Lists.content2 []
                [ Options.span [ onClick <| VisAktivitetDeltakerDetalj deltaker.id, cs "editer-aktivitet" ]
                    [ Lists.icon "mode_edit" []
                    ]
                ]
            ]