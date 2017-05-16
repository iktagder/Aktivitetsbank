module Pages.Aktiviteter.Aktivitet exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Menu as Menu
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.Tooltip as Tooltip
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
import Shared.Tilgang exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Dropdown


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , aktivitetId : String
    , aktivitet : WebData Aktivitet
    , deltakere : WebData (List Deltaker)
    , appMetadata : WebData AppMetadata
    , dropdownStateSkole : Dropdown.State
    , dropdownStateAktivitetstype : Dropdown.State
    , bekreftSletting : BekreftSletting
    }


type BekreftSletting
    = Av
    | VisBekreftSletting
    | SlettingBekreftet
    | SlettingAvbrutt


type Msg
    = Mdl (Material.Msg Msg)
    | VisAktivitetDeltakerDetalj String
    | VisAktivitetEndre String
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetResponse (WebData Aktivitet)
    | AktivitetDeltakereResponse (WebData (List Deltaker))
    | OnSelectSkole (Maybe Skole)
    | SkoleDropdown (Dropdown.Msg Skole)
    | OnSelectAktivitetstype (Maybe AktivitetsType)
    | AktivitetstypeDropdown (Dropdown.Msg AktivitetsType)
    | VisDeltakerOpprett
    | SlettAktivitet BekreftSletting
    | NavigerHjem
    | NavigerTilEndreDeltaker String String
    | KopierAktivitetTilSkole Skole
    | KopierAktivitetRespons (Result Error KopiertAktivitet)
    | SlettAktivitetRespons (Result Error ())


init : String -> String -> ( Model, Cmd Msg )
init apiEndpoint id =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , aktivitetId = id
      , aktivitet = RemoteData.NotAsked
      , deltakere = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      , dropdownStateSkole = Dropdown.newState "1"
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      , bekreftSletting = Av
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


postKopierAktivitet : String -> String -> AktivitetGyldigKopier -> (Result Error KopiertAktivitet -> msg) -> Cmd msg
postKopierAktivitet endPoint aktivitetId aktivitetKopi responseMsg =
    let
        url =
            endPoint ++ "aktiviteter/" ++ aktivitetId ++ "/kopier"

        body =
            encodeKopierAktivitet aktivitetKopi |> Http.jsonBody

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


deleteSlettAktivitet : String -> String -> (Result Error () -> msg) -> Cmd msg
deleteSlettAktivitet endPoint aktivitetId responseMsg =
    let
        url =
            endPoint ++ "aktiviteter/" ++ aktivitetId

        body =
            Http.emptyBody

        req =
            Http.request
                { method = "DELETE"
                , headers = []
                , url = url
                , body = body
                , expect = Http.expectStringResponse (\_ -> Ok ())
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

        VisAktivitetDeltakerDetalj id ->
            ( model, Cmd.none, NoSharedMsg )

        VisAktivitetEndre id ->
            ( model, Cmd.none, NavigerTilAktivitetEndre id )

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

        NavigerTilEndreDeltaker aktivitetId deltakerId ->
            ( model, Cmd.none, NavigerTilDeltakerEndre aktivitetId deltakerId )

        KopierAktivitetTilSkole skole ->
            let
                aktivitetKopi =
                    { id = model.aktivitetId, skoleId = skole.id }
            in
                ( model, postKopierAktivitet model.apiEndpoint model.aktivitetId aktivitetKopi KopierAktivitetRespons, NoSharedMsg )

        KopierAktivitetRespons (Ok nyId) ->
            let
                tmp =
                    Debug.log "ny aktivitet" nyId
            in
                ( model, Cmd.none, NavigateToAktivitet nyId.id )

        KopierAktivitetRespons (Err error) ->
            let
                ( cmd, statusText, _ ) =
                    case error of
                        Http.BadUrl info ->
                            ( Cmd.none, "Feil i url til API.", 0 )

                        Http.BadPayload _ _ ->
                            ( Cmd.none, "Feil i innhold ved sending av data til API.", 0 )

                        Http.BadStatus status ->
                            ( Cmd.none, "Feil i sending av data til API.", 0 )

                        Http.NetworkError ->
                            ( Cmd.none, "Feil i sending av data til API. Nettverksfeil.", 0 )

                        Http.Timeout ->
                            ( Cmd.none, "Nettverksfeil - timet ut ved kall til API.", 0 )
            in
                ( { model | statusText = statusText }, cmd, NoSharedMsg )

        SlettAktivitet bekreft ->
            let
                ( bekreftStatus, cmd ) =
                    case bekreft of
                        Av ->
                            ( bekreft, Cmd.none )

                        VisBekreftSletting ->
                            ( bekreft, Cmd.none )

                        SlettingBekreftet ->
                            ( bekreft, deleteSlettAktivitet model.apiEndpoint model.aktivitetId SlettAktivitetRespons )

                        SlettingAvbrutt ->
                            ( Av, Cmd.none )
            in
                ( { model | bekreftSletting = bekreftStatus }, cmd, NoSharedMsg )

        SlettAktivitetRespons (Ok _) ->
            let
                tmp =
                    Debug.log "slettet aktivitet" model.aktivitetId
            in
                ( { model | bekreftSletting = Av }, Cmd.none, NavigerTilHjem )

        SlettAktivitetRespons (Err error) ->
            let
                ( cmd, statusText, _ ) =
                    case error of
                        Http.BadUrl info ->
                            ( Cmd.none, "Feil i url til API.", 0 )

                        Http.BadPayload _ _ ->
                            ( Cmd.none, "Feil i innhold ved sending av data til API.", 0 )

                        Http.BadStatus status ->
                            ( Cmd.none, "Feil i sending av data til API.", 0 )

                        Http.NetworkError ->
                            ( Cmd.none, "Feil i sending av data til API. Nettverksfeil.", 0 )

                        Http.Timeout ->
                            ( Cmd.none, "Nettverksfeil - timet ut ved kall til API.", 0 )
            in
                ( { model | statusText = statusText }, cmd, NoSharedMsg )


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        (visHeading taco model :: visAktivitet model ++ visAktivitetDeltakere taco model)


visHeading : Taco -> Model -> Grid.Cell Msg
visHeading taco model =
    cell
        [ size All 12
        ]
        [ Icon.view "home"
            [ Tooltip.attach Mdl [ 123, 100 ]
            , Options.css "float" "right"
            , Icon.size24
            , cs "standard-ikon"
            , Options.onClick NavigerHjem
            ]
        , Tooltip.render Mdl
            [ 123
            , 100
            ]
            model.mdl
            [ Tooltip.large
            ]
            [ text "Gå til hovedside"
            ]

        -- , Icon.view "content_copy"
        --     [ Tooltip.attach Mdl
        --         [ 124
        --         , 100
        --         ]
        --     , Options.css "float" "right"
        --     , Icon.size24
        --     , cs "vis-navigering"
        --     ]
        -- , Tooltip.render Mdl
        --     [ 124
        --     , 100
        --     ]
        --     model.mdl
        --     [ Tooltip.large ]
        --     [ text "Kopier aktivitet" ]
        , (visKopierAktivitetMeny model)
            |> visVedKanRedigere taco
        , (visEditerAktivitetIkon model)
            |> visVedKanRedigere taco
        , (visSlettAktivitet model)
            |> visVedKanRedigere taco
        , Options.span
            [ Typo.headline
            , Options.css "padding" "16px 32px"
            ]
            [ text "Aktivitet detaljer" ]
        ]


visEditerAktivitetIkon : Model -> Taco -> Html Msg
visEditerAktivitetIkon model taco =
    Options.span [ Options.css "float" "right" ]
        [ Icon.view "mode_edit"
            [ Tooltip.attach Mdl [ 125, 100 ]
            , Options.css "float" "right"
            , Options.onClick <| VisAktivitetEndre model.aktivitetId
            , Icon.size24
            , cs "standard-ikon"
            ]
        , Tooltip.render Mdl [ 125, 100 ] model.mdl [ Tooltip.large ] [ text "Endre aktivitet" ]
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
            , p []
                [ Options.styled div [ Typo.caption ] [ text "Skoleår: " ]
                , Options.styled div [ Typo.subhead ] [ text (aktivitet.skoleAarNavn) ]
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


visAktivitetDeltakere : Taco -> Model -> List (Grid.Cell Msg)
visAktivitetDeltakere taco model =
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
            visAktivitetDeltakereSuksess taco model data


visAktivitetDeltakereSuksess : Taco -> Model -> List Deltaker -> List (Grid.Cell Msg)
visAktivitetDeltakereSuksess taco model deltakere =
    [ cell
        [ size All 12
        , Elevation.e0
        , css "flex-direction" "row"
        , css "align-items" "stretch"
        , css "justify-content" "flex-start"
        , css "align-content" "stretch"

        -- , Options.css "padding" "16px 32px"
        ]
        -- [ showText span Typo.headline "Deltakere"
        -- , Tooltip.attach Mdl [ 120 ] ], Tooltip.render Mdl [ 120 ] outerMdl [ Tooltip.large ] [ text "Endre deltaker" ]
        [ Options.span
            [ Typo.headline
            , Options.css "float" "left"
            , Options.css "margin" "16px 16px"
            ]
            [ text "Deltakere" ]
        , (visLeggTilDeltakerIkon model)
            |> visVedKanRedigere taco
        ]
    , cell
        [ size All 12
        , Elevation.e0

        -- , Options.css "padding" "16px 32px"
        ]
        -- [ visAktivitetDeltakerListe model deltakere
        [ visAktivitetDeltakerTabell taco model deltakere
        ]

    -- , cell
    --     [ size All 12
    --     , Elevation.e0
    --     -- , Options.css "padding" "16px 32px"
    --     -- , Options.css "display" "flex"
    --     -- , Options.css "flex-direction" "column"
    --     -- , Options.css "float" "left"
    --     , css "flex-direction" "row"
    --     , css "align-items" "stretch"
    --     , css "justify-content" "flex-start"
    --     , css "align-content" "stretch"
    --     -- , Options.css "align-items" "left"
    --     ]
    --     [ Options.span [ Typo.menu, Options.css "float" "left" ] [ text "Legg til deltaker" ]
    --     , Button.render Mdl
    --         [ 0, 4, 2 ]
    --         model.mdl
    --         [ Button.fab
    --         , Button.ripple
    --         , Options.onClick VisDeltakerOpprett
    --         , Options.css "float" "left"
    --         ]
    --         [ Icon.i "add" ]
    --     ]
    ]


visLeggTilDeltakerIkon : Model -> Taco -> Html Msg
visLeggTilDeltakerIkon model taco =
    Options.span [ Options.css "float" "left" ]
        [ Icon.view "add"
            [ Tooltip.attach Mdl
                [ 121
                ]
            , Options.css "float" "left"
            , Options.onClick VisDeltakerOpprett
            , Icon.size24
            , Options.css "margin" "12px 16px"
            , cs "vis-navigering"
            ]
        , Tooltip.render Mdl [ 121 ] model.mdl [ Tooltip.large ] [ text "Opprett deltaker på aktiviteten" ]
        ]


visAktivitetDeltakerTabell : Taco -> Model -> List Deltaker -> Html Msg
visAktivitetDeltakerTabell taco model deltakere =
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
                , Table.th [ css "width" "15%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Fag"
                    ]
                , Table.th [ css "width" "10%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Timer"
                    ]
                , Table.th [ css "width" "40%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Kompetansemål"
                    ]
                , Table.th [ css "width" "5%" ]
                    [ if kanRedigere taco then
                        showText div Typo.body2 "Handling"
                      else
                        text ""
                    ]
                ]
            ]
        , Table.tbody []
            (deltakere
                |> List.indexedMap (\idx item -> visAktivitetDeltakerTabellRad idx taco model.aktivitetId item model.mdl)
            )
        ]


visAktivitetDeltakerTabellRad : Int -> Taco -> String -> Deltaker -> Material.Model -> Html Msg
visAktivitetDeltakerTabellRad idx taco aktivitetId model outerMdl =
    let
        aksjon =
            if kanRedigere taco then
                Table.td [] [ Icon.view "mode_edit" [ cs "vis-navigering", Options.onClick (NavigerTilEndreDeltaker aktivitetId model.id), Tooltip.attach Mdl [ 120 ] ], Tooltip.render Mdl [ 120 ] outerMdl [ Tooltip.large ] [ text "Endre deltaker" ] ]
            else
                Table.td [] []
    in
        Table.tr
            []
            [ Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.utdanningsprogramNavn ]
            , Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.trinnNavn ]
            , Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.fagNavn ]
            , Table.td [ Table.numeric ] [ text <| toString model.timer ]
            , Table.td [ css "text-align" "left", cs "wrapword" ] [ text (String.left 600 model.kompetansemaal) ]
            , aksjon
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


visKopierAktivitetMeny : Model -> Taco -> Html Msg
visKopierAktivitetMeny model taco =
    Options.div []
        [ Menu.render Mdl
            [ 22, 33, 44 ]
            model.mdl
            [ css "float" "right"
            , Tooltip.attach Mdl
                [ 3124
                , 100
                ]
            , Menu.ripple
            , Menu.bottomRight
            , Menu.icon "content_copy"

            -- , Menu.icon "keyboard_arrow_down"
            ]
            (visKopiAktivitetSkoler model)
        , Tooltip.render Mdl
            [ 3124
            , 100
            ]
            model.mdl
            [ Tooltip.large ]
            [ text "Kopier aktivitet" ]
        ]



-- , Icon.view "content_copy"
--     [ Tooltip.attach Mdl
--         [ 124
--         , 100
--         ]
--     , Options.css "float" "right"
--     , Icon.size24
--     , cs "vis-navigering"
--     ]
-- , Tooltip.render Mdl
--     [ 124
--     , 100
--     ]
--     model.mdl
--     [ Tooltip.large ]
--     [ text "Kopier aktivitet" ]


visKopiAktivitetSkoler : Model -> List (Menu.Item Msg)
visKopiAktivitetSkoler model =
    case model.appMetadata of
        Success metadata ->
            metadata.skoler
                -- |> List.filter (\availableLanguage -> not (List.any (\language -> language == availableLanguage.name) displayLanguages))
                |> List.map (\skole -> visKopierAktivitetSkole skole)

        _ ->
            []


visKopierAktivitetSkole : Skole -> Menu.Item Msg
visKopierAktivitetSkole skole =
    Menu.item
        [ Menu.onSelect (KopierAktivitetTilSkole skole) ]
        [ text skole.navn ]


visSlettAktivitet : Model -> Taco -> Html Msg
visSlettAktivitet model taco =
    case model.bekreftSletting of
        Av ->
            visSlettAktivitetIkon model

        VisBekreftSletting ->
            visSlettAktivitetBekreft model

        SlettingBekreftet ->
            text "Sletter aktivitet"

        SlettingAvbrutt ->
            text "Sletting avbrutt"


visSlettAktivitetIkon : Model -> Html Msg
visSlettAktivitetIkon model =
    Options.span [ Options.css "float" "right" ]
        [ Icon.view "delete_sweep"
            [ Tooltip.attach Mdl [ 145, 100 ]
            , Options.css "float" "right"
            , Options.onClick <| SlettAktivitet VisBekreftSletting
            , Icon.size24
            , cs "standard-ikon"
            ]
        , Tooltip.render Mdl [ 145, 100 ] model.mdl [ Tooltip.large ] [ text "Slett aktivitet" ]
        ]


visSlettAktivitetBekreft : Model -> Html Msg
visSlettAktivitetBekreft model =
    Options.span [ Options.css "float" "right" ]
        [ Options.styled div [ Typo.title ] [ text "Vil du virkelig slette denne aktiviteten?" ]
        , Button.render Mdl
            [ 347, 1 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.onClick (SlettAktivitet SlettingAvbrutt)
            , css "float" "left"
            , Options.css "margin" "6px 6px"
            ]
            [ text "Avbryt" ]
        , Button.render Mdl
            [ 41, 404 ]
            model.mdl
            [ Button.ripple
            , Button.accent
            , Button.raised
            , Options.onClick (SlettAktivitet SlettingBekreftet)
            , css "float" "left"
            , Options.css "margin" "6px 6px"
            ]
            [ text "Bekreft sletting" ]
        ]
