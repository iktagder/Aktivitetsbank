module Pages.Aktiviteter.Aktiviteter exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Button as Button
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Table as Table
import Material.List as Lists
import Material.Textfield as Textfield
import Material.Toggles as Toggles
import Material.Spinner as Loading
import Material.Typography as Typography
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Shared.Tilgang exposing (..)
import Views.StandardFilter exposing (..)


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , aktivitetListe : WebData (List Aktivitet)
    , filtertAktivitetListe : List Aktivitet
    , appMetadata : WebData AppMetadata
    , visFilter : Bool
    , filter : Filter
    }


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , aktivitetListe = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      , visFilter = False
      , filtertAktivitetListe = []
      , filter = initFilter
      }
    , Cmd.batch [ fetchAppMetadata apiEndpoint, fetchAktivitetListe apiEndpoint ]
    )


initFilter : Filter
initFilter =
    { ekspandertFilter = IngenFilterEkspandert

    -- { ekspandertFilter = SkoleFilterEkspandert
    , navnFilter = ""
    , skoleFilter = []
    , aktivitetsTypeFilter = []
    }


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


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetListeResponse (WebData (List Aktivitet))
    | VisAktivitetDetalj String
    | OpprettAktivitet
    | VisFilter
    | FiltrerPaNavn String
    | FilterMetadata FilterType
    | NullstillFilter
    | EkspanderFilterType EkspandertFilter


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
            ( model, Cmd.none, NavigerTilAktivitetOpprett )

        VisFilter ->
            ( { model | visFilter = not model.visFilter, filtertAktivitetListe = (getAktivitetListe model) }, Cmd.none, NoSharedMsg )

        FiltrerPaNavn navn ->
            let
                filter_ =
                    model.filter

                nyttFilter =
                    { filter_ | navnFilter = navn }
            in
                ( { model
                    | filter = nyttFilter
                    , filtertAktivitetListe = filterAktivitetList model navn model.filter.aktivitetsTypeFilter model.filter.skoleFilter
                  }
                , Cmd.none
                , NoSharedMsg
                )

        FilterMetadata filterType ->
            case filterType of
                AktivitetsTypeFilter typeId ->
                    let
                        nyttAktivitetsTypeFilter =
                            if List.member typeId model.filter.aktivitetsTypeFilter then
                                List.filter (\x -> x /= typeId) model.filter.aktivitetsTypeFilter
                            else
                                typeId :: model.filter.aktivitetsTypeFilter

                        gammeltFilter =
                            model.filter

                        nyttFilter =
                            { gammeltFilter | aktivitetsTypeFilter = nyttAktivitetsTypeFilter }
                    in
                        ( { model
                            | filtertAktivitetListe = filterAktivitetList model model.filter.navnFilter nyttAktivitetsTypeFilter model.filter.skoleFilter
                            , filter = nyttFilter
                          }
                        , Cmd.none
                        , NoSharedMsg
                        )

                SkoleFilter skoleId ->
                    let
                        nyttSkoleFilter =
                            if List.member skoleId model.filter.skoleFilter then
                                List.filter (\x -> x /= skoleId) model.filter.skoleFilter
                            else
                                skoleId :: model.filter.skoleFilter

                        gammeltFilter =
                            model.filter

                        nyttFilter =
                            { gammeltFilter | skoleFilter = nyttSkoleFilter }
                    in
                        ( { model
                            | filtertAktivitetListe = filterAktivitetList model model.filter.navnFilter model.filter.aktivitetsTypeFilter nyttSkoleFilter
                            , filter = nyttFilter
                          }
                        , Cmd.none
                        , NoSharedMsg
                        )

        NullstillFilter ->
            ( { model | filter = initFilter, filtertAktivitetListe = (getAktivitetListe model) }, Cmd.none, NoSharedMsg )

        EkspanderFilterType ekspandertFilter ->
            let
                gammeltFilter =
                    model.filter

                nyttEkspandertFilter =
                    if ekspandertFilter == gammeltFilter.ekspandertFilter then
                        IngenFilterEkspandert
                    else
                        ekspandertFilter

                nyttFilter =
                    { gammeltFilter | ekspandertFilter = nyttEkspandertFilter }
            in
                ( { model | filter = nyttFilter }, Cmd.none, NoSharedMsg )


filterAktivitetList : Model -> String -> List String -> List String -> List Aktivitet
filterAktivitetList model navn aktivitetsType skole =
    (getAktivitetListe model)
        |> List.filter
            (\aktivitet ->
                if List.isEmpty aktivitetsType then
                    True
                else
                    List.member aktivitet.aktivitetsTypeId aktivitetsType
            )
        |> List.filter
            (\aktivitet ->
                if String.isEmpty navn then
                    True
                else
                    String.contains (String.toLower navn) (String.toLower aktivitet.navn)
            )
        |> List.filter
            (\aktivitet ->
                if List.isEmpty skole then
                    True
                else
                    List.member aktivitet.skoleId skole
            )


getAktivitetListe : Model -> List Aktivitet
getAktivitetListe model =
    case model.aktivitetListe of
        Success data ->
            data

        _ ->
            []


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        [ cell
            [ size All 12
            ]
            [ (visOpprettAktivitetIkon model)
                |> visVedKanRedigere taco
            , (visFilterIkon taco model)
            , Options.span
                [ Typo.headline
                , Options.css "padding" "16px 32px"
                ]
                [ text "Aktiviteter" ]
            ]
        , getFilterCell model
        , cell
            [ size All (getAntallAktivietCeller model)
            , Elevation.e0
            , Options.css "padding" "16px 32px"
            ]
            [ viewMainContent model
            ]
        ]


visOpprettAktivitetIkon : Model -> Taco -> Html Msg
visOpprettAktivitetIkon model taco =
    Options.span [ Options.css "float" "right" ]
        [ Icon.view "add"
            [ Tooltip.attach Mdl [ 123, 100 ]
            , Options.css "float" "right"
            , Icon.size24
            , cs "standard-ikon"
            , Options.onClick OpprettAktivitet
            ]
        , Tooltip.render Mdl
            [ 123
            , 100
            ]
            model.mdl
            [ Tooltip.large
            ]
            [ text "Opprett aktivitet"
            ]
        ]


visFilterIkon : Taco -> Model -> Html Msg
visFilterIkon taco model =
    Options.span [ Options.css "float" "right" ]
        [ Icon.view "search"
            [ Tooltip.attach Mdl
                [ 124
                , 100
                ]
            , Options.css "float" "right"
            , Icon.size24
            , cs "standard-ikon"
            , Options.onClick VisFilter
            ]
        , Tooltip.render Mdl
            [ 124
            , 100
            ]
            model.mdl
            [ Tooltip.large ]
            [ text "Filtrer aktiviteter" ]
        ]


getAntallAktivietCeller : Model -> Int
getAntallAktivietCeller model =
    if model.visFilter then
        9
    else
        12


getFilterCell : Model -> Grid.Cell Msg
getFilterCell model =
    case
        model.visFilter
    of
        True ->
            cell
                [ size All 3
                , Elevation.e2
                ]
                [ visFilter model
                ]

        _ ->
            cell
                []
                []


visFilter : Model -> Html Msg
visFilter model =
    let
        konfigurasjon =
            { filterMsg = FilterMetadata
            , nullstillMsg = NullstillFilter
            , filterNavnMsg = FiltrerPaNavn
            , ekspanderFilterTypeMsg = EkspanderFilterType
            , mdlMsg = Mdl
            , mdlModel = model.mdl
            }
    in
        visStandardFilter model.appMetadata model.filter konfigurasjon


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
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            -- visAktivitetListeSuksess model data
            visAktivitetTabellSuksess model data


visAktivitetListeSuksess : Model -> List Aktivitet -> Html Msg
visAktivitetListeSuksess model aktiviteter =
    Lists.ul [ css "width" "100%" ]
        (getAktiviteter model aktiviteter
            |> List.map (visAktivitet model)
        )


visAktivitetTabellSuksess : Model -> List Aktivitet -> Html Msg
visAktivitetTabellSuksess model aktiviteter =
    Table.table [ css "table-layout" "fixed", css "width" "100%" ]
        [ Table.thead
            []
            [ Table.tr []
                [ Table.th
                    [ css "width" "20%" ]
                    [ showText div Typo.body2 "Navn"
                    ]
                , Table.th [ css "width" "10%" ]
                    [ showText div Typo.body2 "Aktivitetstype"
                    ]
                , Table.th [ css "width" "10%" ]
                    [ showText div Typo.body2 "Skole"
                    ]
                , Table.th [ css "width" "5%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Skoleår"
                    ]
                , Table.th [ css "width" "5%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Timer"
                    ]
                , Table.th [ css "width" "50%", css "text-align" "left" ]
                    [ showText span Typo.body2 "Beskrivelse"
                    ]
                ]
            ]
        , Table.tbody []
            (getAktiviteter model aktiviteter
                |> List.sortBy .navn
                |> List.indexedMap (\idx item -> visAktivitetTabellRad idx item model.mdl)
            )
        ]


getAktiviteter : Model -> List Aktivitet -> List Aktivitet
getAktiviteter model aktiviteter =
    case model.visFilter of
        True ->
            model.filtertAktivitetListe

        False ->
            aktiviteter


visAktivitetTabellRad : Int -> Aktivitet -> Material.Model -> Html Msg
visAktivitetTabellRad idx model outerMdl =
    Table.tr
        [ onClick <| VisAktivitetDetalj model.id, cs "vis-navigering" ]
        [ Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.navn ]
        , Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.aktivitetsTypeNavn ]
        , Table.td [ css "text-align" "left", cs "wrapword" ] [ text model.skoleNavn ]
        , Table.td [ css "text-align" "left" ] [ text model.skoleAarNavn ]
        , Table.td [ Table.numeric ] [ text <| toString model.omfangTimer ]
        , Table.td [ css "text-align" "left", cs "wrapword" ] [ text (String.left 600 model.beskrivelse) ]
        ]


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
        Lists.li [ Lists.withSubtitle, onClick <| VisAktivitetDetalj aktivitet.id, cs "vis-navigering" ]
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
                [ text <| String.left 1 aktivitet.aktivitetsTypeNavn ]
            , Lists.content []
                [ Options.span [] [ text <| aktivitet.navn ++ " - " ++ aktivitet.skoleNavn ++ " (" ++ (toString aktivitet.omfangTimer) ++ " klokketimer ) - " ++ aktivitet.aktivitetsTypeNavn ]
                , Lists.subtitle [ css "width" "80%" ] [ text aktivitet.beskrivelse ]
                ]

            -- , Lists.content2 []
            --     [ Options.span [ onClick <| VisAktivitetDetalj aktivitet.id, cs "editer-aktivitet" ]
            --         [ Lists.icon "mode_edit" []
            --         ]
            --     ]
            ]
