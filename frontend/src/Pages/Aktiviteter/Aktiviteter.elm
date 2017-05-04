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
import Material.Textfield as Textfield
import Material.Toggles as Toggles
import Material.Spinner as Loading
import Material.Typography as Typography
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Dict


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , aktivitetListe : WebData (List Aktivitet)
    , filtertAktivitetListe : List Aktivitet
    , appMetadata : WebData AppMetadata
    , visFilter : Bool
    , aktivitetsTypefilter : Dict.Dict Int String
    , skoleFilter : Dict.Dict Int String
    , navnFilter : String
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetListeResponse (WebData (List Aktivitet))
    | VisAktivitetDetalj String
    | OpprettAktivitet
    | VisFilter
    | FiltrerPaNavn String
    | FiltrerPaType String Int
    | FiltrerPaSkole String Int


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , aktivitetListe = RemoteData.NotAsked
      , appMetadata = RemoteData.NotAsked
      , visFilter = False
      , filtertAktivitetListe = []
      , aktivitetsTypefilter = Dict.empty
      , navnFilter = ""
      , skoleFilter = Dict.empty
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
            ( model, Cmd.none, NavigerTilAktivitetOpprett )

        VisFilter ->
            ( { model | visFilter = not model.visFilter, filtertAktivitetListe = (getAktivitetListe model) }, Cmd.none, NoSharedMsg )

        FiltrerPaNavn navn ->
            ( { model
                | navnFilter = navn
                , filtertAktivitetListe = filterAktivitetList model navn model.aktivitetsTypefilter model.skoleFilter
              }
            , Cmd.none
            , NoSharedMsg
            )

        FiltrerPaType typeId index ->
            let
                newAktivitetsTypefilter =
                    if Dict.member index model.aktivitetsTypefilter then
                        Dict.remove index model.aktivitetsTypefilter
                    else
                        Dict.insert index typeId model.aktivitetsTypefilter
            in
                ( { model
                    | filtertAktivitetListe = filterAktivitetList model model.navnFilter newAktivitetsTypefilter model.skoleFilter
                    , aktivitetsTypefilter = newAktivitetsTypefilter
                  }
                , Cmd.none
                , NoSharedMsg
                )

        FiltrerPaSkole skoleId index ->
            let
                newSkoleFilter =
                    if Dict.member index model.skoleFilter then
                        Dict.remove index model.skoleFilter
                    else
                        Dict.insert index skoleId model.skoleFilter
            in
                ( { model
                    | filtertAktivitetListe = filterAktivitetList model model.navnFilter model.aktivitetsTypefilter newSkoleFilter
                    , skoleFilter = newSkoleFilter
                  }
                , Cmd.none
                , NoSharedMsg
                )


filterAktivitetList : Model -> String -> Dict.Dict Int String -> Dict.Dict Int String -> List Aktivitet
filterAktivitetList model navn aktivitetsType skole =
    (getAktivitetListe model)
        |> List.filter
            (\aktivitet ->
                if Dict.isEmpty aktivitetsType then
                    True
                else
                    List.member aktivitet.aktivitetsTypeId (Dict.values aktivitetsType)
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
                if Dict.isEmpty skole then
                    True
                else
                    List.member aktivitet.skoleId (Dict.values skole)
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
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.fab
                , Button.ripple
                , Options.onClick OpprettAktivitet
                , Options.css "float" "right"
                , Options.css "margin-left" "3px"
                ]
                [ Icon.i "add" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.fab
                , Button.ripple
                , Options.onClick VisFilter
                , Options.css "float" "right"
                ]
                [ Icon.i "search" ]
            , Options.span [ Typo.title ]
                [ text "Aktiviteter" ]
            ]
        , getFilterCell model
        , cell
            [ size All (getAntallAktivietCeller model)
            , Elevation.e2
            ]
            [ viewMainContent model
            ]
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
    Options.div
        [ css "margin-top"
            "5px"
        , css
            "margin-left"
            "5px"
        ]
        [ Options.div [ Typo.title ]
            [ text "Filtrer" ]
        , Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Navn"
            , Textfield.floatingLabel
            , Textfield.text_
            , Options.onInput (FiltrerPaNavn)
            ]
            []
        , visAvansertFilter model
        ]


visAvansertFilter : Model -> Html Msg
visAvansertFilter model =
    case model.appMetadata of
        NotAsked ->
            text "Venter på henting av metadata.."

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            visAvansertFilterSuksess model data


visAvansertFilterSuksess : Model -> AppMetadata -> Html Msg
visAvansertFilterSuksess model data =
    Options.div []
        [ text "Aktivitetstyper"
        , Options.div []
            (data.aktivitetstyper
                |> List.indexedMap (\index item -> visAktivitetTypeFilter model item index)
            )
        , text "Skoler"
        , Options.div []
            (data.skoler
                |> List.indexedMap (\index item -> visSkoleTypeFilter model item index)
            )
        ]


visAktivitetTypeFilter : Model -> AktivitetsType -> Int -> Html Msg
visAktivitetTypeFilter model type_ index =
    Toggles.checkbox Mdl
        [ 5, index ]
        model.mdl
        [ Options.onToggle (FiltrerPaType type_.id index)
        , Toggles.ripple
        , Toggles.value (Dict.member index model.aktivitetsTypefilter)
        ]
        [ text type_.navn ]


visSkoleTypeFilter : Model -> Skole -> Int -> Html Msg
visSkoleTypeFilter model skole index =
    Toggles.checkbox Mdl
        [ 9, index ]
        model.mdl
        [ Options.onToggle (FiltrerPaSkole skole.id index)
        , Toggles.ripple
        , Toggles.value (Dict.member index model.skoleFilter)
        ]
        [ text skole.navn ]


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
            visAktivitetListeSuksess model data


visAktivitetListeSuksess : Model -> List Aktivitet -> Html Msg
visAktivitetListeSuksess model aktiviteter =
    Lists.ul [ css "width" "100%" ]
        (getAktiviteter model aktiviteter
            |> List.map (visAktivitet model)
        )


getAktiviteter : Model -> List Aktivitet -> List Aktivitet
getAktiviteter model aktiviteter =
    case model.visFilter of
        True ->
            model.filtertAktivitetListe

        False ->
            aktiviteter


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
                [ text <| String.left 1 aktivitet.aktivitetsTypeNavn ]
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
