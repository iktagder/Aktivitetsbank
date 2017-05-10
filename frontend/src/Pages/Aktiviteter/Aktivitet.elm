module Pages.Aktiviteter.Aktivitet exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.List as Lists
import Material.Table as Table
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
    , dropdownStateSkole : Dropdown.State
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
    | VisDeltakerOpprett
    | NavigerHjem


init : String -> String -> ( Model, Cmd Msg )
init apiEndpoint id =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , aktivitet = RemoteData.NotAsked
      , deltakere = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      , dropdownStateSkole = Dropdown.newState "1"
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      }
    , Cmd.batch
        [ (hentAktivitetDetalj id apiEndpoint)
        , (hentAktivitetDeltakere id apiEndpoint)
        , fetchAppMetadata apiEndpoint
        ]
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

        VisDeltakerOpprett ->
            let
                sharedMsg =
                    case model.aktivitet of
                        Success aktivitet ->
                            NavigerTilDeltakerOpprett aktivitet.id

                        _ ->
                            NoSharedMsg
            in
                ( model, Cmd.none, sharedMsg )

        AktivitetDeltakereResponse response ->
            ( { model | deltakere = Debug.log "Deltakere:" response }, Cmd.none, NoSharedMsg )

        AktivitetResponse response ->
            ( Debug.log "aktivitet-item-response" { model | aktivitet = response }, Cmd.none, NoSharedMsg )

        OnSelectSkole skole ->
            let
                oppdatertAktivitet =
                    case model.aktivitet of
                        Success data ->
                            RemoteData.Success { data | skole = skole }

                        _ ->
                            model.aktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        SkoleDropdown skole ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigSkole skole model.dropdownStateSkole
            in
                ( { model | dropdownStateSkole = updated }, cmd, NoSharedMsg )

        OnSelectAktivitetstype aktivitetstype ->
            let
                oppdatertAktivitet =
                    case model.aktivitet of
                        Success data ->
                            RemoteData.Success { data | aktivitetsType = aktivitetstype }

                        _ ->
                            model.aktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet }, Cmd.none, NoSharedMsg )

        AktivitetstypeDropdown aktivitetstype ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigAktivitetstype aktivitetstype model.dropdownStateAktivitetstype
            in
                ( { model | dropdownStateAktivitetstype = updated }, cmd, NoSharedMsg )

        NavigerHjem ->
            ( model, Cmd.none, NavigerTilHjem )


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        (visHeading model :: visAktivitet model ++ visAktivitetDeltakere model)


visHeading : Model -> Grid.Cell Msg
visHeading model =
    cell
        [ size All 12
        ]
        [ Button.render Mdl
            [ 199, 1 ]
            model.mdl
            [ Button.fab
            , Button.ripple
            , Options.onClick NavigerHjem
            , Options.css "float" "right"
            ]
            [ Icon.i "home" ]
        , Button.render Mdl
            [ 199, 2 ]
            model.mdl
            [ Button.fab
            , Button.ripple

            -- , Options.onClick OpprettAktivitet
            , Options.css "float" "right"
            ]
            [ Icon.i "content_copy" ]
        , Options.span [ Typo.headline ] [ text "Aktivitet detaljer" ]
        ]


visAktivitet : Model -> List (Grid.Cell Msg)
visAktivitet model =
    case model.aktivitet of
        NotAsked ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ text "Venter på henting av .."
                ]
            ]

        Loading ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ Options.div []
                    [ Loading.spinner [ Loading.active True ]
                    ]
                ]
            ]

        Failure err ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ text "Feil ved henting av data"
                ]
            ]

        Success data ->
            visAktivitetSuksess model data


visAktivitetSuksess : Model -> Aktivitet -> List (Grid.Cell Msg)
visAktivitetSuksess model aktivitet =
    [ cell
        [ size All 4
        , Elevation.e0
        , Options.css "padding" "0px 32px"

        -- , Options.css "display" "flex"
        -- , Options.css "flex-direction" "column"
        -- , Options.css "align-items" "left"
        ]
        [ Options.div
            [ css "width" "100%"
            ]
            [ p []
                [ Options.styled div [ Typo.title ] [ text aktivitet.navn ]
                ]
            , p []
                [ Options.styled div [ Typo.caption ] [ text "Beskrivelse: " ]
                , Options.styled div [ Typo.subhead ] [ text (aktivitet.beskrivelse) ]
                ]
            ]
        ]
    , cell
        [ size All 8
        , Elevation.e0
        , Options.css "padding" "16px 32px"

        -- , Options.css "display" "flex"
        -- , Options.css "flex-direction" "column"
        -- , Options.css "align-items" "left"
        ]
        [ Options.div
            [ css "width" "100%"
            ]
            [ p []
                [ Options.styled div [ Typo.caption ] [ text "Klokketimer: " ]
                , Options.styled div [ Typo.subhead ] [ text (toString aktivitet.omfangTimer) ]
                ]
            , p []
                [ Options.styled div [ Typo.caption ] [ text "Skole: " ]
                , Options.styled div [ Typo.subhead ] [ text (aktivitet.skoleNavn) ]
                ]
            , p []
                [ Options.styled div [ Typo.caption ] [ text "Aktivitetstype" ]
                , Options.styled div [ Typo.subhead ] [ text aktivitet.aktivitetsTypeNavn ]
                ]
            ]
        ]
    ]


visSkole : Model -> Aktivitet -> Html Msg
visSkole model aktivitet =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visSkoleDropdown
                aktivitet.skole
                data.skoler
                model.dropdownStateSkole


visSkoleDropdown : Maybe Skole -> List Skole -> Dropdown.State -> Html Msg
visSkoleDropdown selectedSkoleId model dropdownStateSkole =
    span []
        [ Html.map SkoleDropdown (Dropdown.view dropdownConfigSkole dropdownStateSkole model selectedSkoleId)
        ]


visAktivitetstype : Model -> Aktivitet -> Html Msg
visAktivitetstype model aktivitet =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visAktivitetstypeDropdown
                aktivitet.aktivitetsType
                data.aktivitetstyper
                model.dropdownStateAktivitetstype


visAktivitetstypeDropdown : Maybe AktivitetsType -> List AktivitetsType -> Dropdown.State -> Html Msg
visAktivitetstypeDropdown selectedAktivitetstypeId model dropdownStateAktivitetstype =
    span []
        [ Html.map AktivitetstypeDropdown (Dropdown.view dropdownConfigAktivitetstype dropdownStateAktivitetstype model selectedAktivitetstypeId)
        ]


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


visAktivitetDeltakere : Model -> List (Grid.Cell Msg)
visAktivitetDeltakere model =
    case model.deltakere of
        NotAsked ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ text "Venter på henting av deltakere.."
                ]
            ]

        Loading ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ Options.div []
                    [ Loading.spinner [ Loading.active True ]
                    ]
                ]
            ]

        Failure err ->
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                ]
                [ text "Feil ved henting av data"
                ]
            ]

        Success data ->
            visAktivitetDeltakereSuksess model data


visAktivitetDeltakereSuksess : Model -> List Deltaker -> List (Grid.Cell Msg)
visAktivitetDeltakereSuksess model deltakere =
    [ cell
        [ size All 12
        , Elevation.e0

        -- , Options.css "padding" "16px 32px"
        ]
        [ showText p Typo.headline "Deltakere"
        ]
    , cell
        [ size All 12
        , Elevation.e0

        -- , Options.css "padding" "16px 32px"
        ]
        -- [ visAktivitetDeltakerListe model deltakere
        [ visAktivitetDeltakerTabell model deltakere
        ]
    , cell
        [ size All 12
        , Elevation.e0

        -- , Options.css "padding" "16px 32px"
        -- , Options.css "display" "flex"
        -- , Options.css "flex-direction" "column"
        -- , Options.css "float" "left"
        , css "flex-direction" "row"
        , css "align-items" "stretch"
        , css "justify-content" "flex-start"
        , css "align-content" "stretch"

        -- , Options.css "align-items" "left"
        ]
        [ Options.span [ Typo.menu, Options.css "float" "left" ] [ text "Legg til deltaker" ]
        , Button.render Mdl
            [ 0, 4, 2 ]
            model.mdl
            [ Button.fab
            , Button.ripple
            , Options.onClick VisDeltakerOpprett
            , Options.css "float" "left"
            ]
            [ Icon.i "add" ]
        ]
    ]


visAktivitetDeltakerTabell : Model -> List Deltaker -> Html Msg
visAktivitetDeltakerTabell model deltakere =
    Table.table [ css "table-layout" "fixed", css "width" "100%" ]
        [ Table.thead
            []
            [ Table.tr []
                [ Table.th
                    [ css "width" "20%" ]
                    [ showText div Typo.body2 "Utdanningsprogram"
                    ]
                , Table.th [ css "width" "10%" ]
                    [ showText div Typo.body2 "Årstrinn"
                    ]
                , Table.th [ css "width" "20%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Fag"
                    ]
                , Table.th [ css "width" "10%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Timer"
                    ]
                , Table.th [ css "width" "40%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Kompetansemål"
                    ]
                ]
            ]
        , Table.tbody []
            (deltakere
                |> List.indexedMap (\idx item -> visAktivitetDeltakerTabellRad idx item model.mdl)
            )
        ]


visAktivitetDeltakerTabellRad : Int -> Deltaker -> Material.Model -> Html msg
visAktivitetDeltakerTabellRad idx model outerMdl =
    Table.tr
        []
        [ Table.td [ css "text-align" "left" ] [ text model.utdanningsprogramNavn ]
        , Table.td [ css "text-align" "left" ] [ text model.trinnNavn ]
        , Table.td [ css "text-align" "left" ] [ text model.fagNavn ]
        , Table.td [ Table.numeric ] [ text <| toString model.timer ]
        , Table.td [ css "text-align" "left", cs "wrapword" ] [ text (String.left 600 model.kompetansemaal) ]
        ]



-- , Table.td []
--     [ Button.render Mdl
--         [ idx ]
--         outerMdl
--         [ Button.minifab
--         , Button.colored
--         , Options.onClick (selectedMsg model.navn)
--         ]
--         [ Icon.view "cancel" [ Tooltip.attach mdlMsg [ idx ] ], Tooltip.render mdlMsg [ idx ] outerMdl [ Tooltip.large ] [ text "Fjern tilgang" ] ]
--     ]


visAktivitetDeltakerListe : Model -> List Deltaker -> Html Msg
visAktivitetDeltakerListe model deltakere =
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
                [ Options.span [] [ text <| deltaker.aktivitetNavn ++ " - " ++ deltaker.trinnNavn ++ " - " ++ deltaker.fagNavn ++ " (" ++ (toString deltaker.timer) ++ " skoletimer )" ]
                , Lists.subtitle [ css "width" "80%" ] [ text deltaker.kompetansemaal ]
                ]
            , Lists.content2 []
                [ Options.span [ onClick <| VisAktivitetDeltakerDetalj deltaker.id, cs "editer-aktivitet" ]
                    [ Lists.icon "mode_edit" []
                    ]
                ]
            ]
