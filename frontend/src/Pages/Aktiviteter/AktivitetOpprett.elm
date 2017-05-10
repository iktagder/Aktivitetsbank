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
import Shared.Validation exposing (..)


type alias Model =
    { mdl : Material.Model
    , apiEndpoint : String
    , statusText : String
    , visLagreKnapp : Bool
    , appMetadata : WebData AppMetadata
    , aktivitet : AktivitetEdit
    , dropdownStateSkole : Dropdown.State
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


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , visLagreKnapp = False
      , appMetadata = RemoteData.NotAsked
      , dropdownStateSkole = Dropdown.newState "1"
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      , aktivitet = initAktivitet
      }
    , fetchAppMetadata apiEndpoint
    )


initAktivitet : AktivitetEdit
initAktivitet =
    { id = Nothing
    , navn = Nothing
    , beskrivelse = Nothing
    , omfangTimer = Nothing
    , skole = Nothing
    , aktivitetsType = Nothing
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


postOpprettNyAktivitet : String -> AktivitetGyldigNy -> (Result Error NyAktivitet -> msg) -> Cmd msg
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

                oppdatertAktivitet =
                    { gammelAktivitet | skole = skole }

                ( visLagreKnapp, statusTekst ) =
                    valideringsInfo oppdatertAktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet, statusText = statusTekst, visLagreKnapp = visLagreKnapp }, Cmd.none, NoSharedMsg )

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

                oppdatertAktivitet =
                    { gammelAktivitet | aktivitetsType = aktivitetstype }

                ( visLagreKnapp, statusTekst ) =
                    valideringsInfo oppdatertAktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet, statusText = statusTekst, visLagreKnapp = visLagreKnapp }, Cmd.none, NoSharedMsg )

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
                    { gammelAktivitet | navn = Just endretNavn }

                ( visLagreKnapp, statusTekst ) =
                    valideringsInfo oppdatertAktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet, statusText = statusTekst, visLagreKnapp = visLagreKnapp }, Cmd.none, NoSharedMsg )

        EndretAktivitetsBeskrivelse endretBeskrivelse ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | beskrivelse = Just endretBeskrivelse }

                ( visLagreKnapp, statusTekst ) =
                    valideringsInfo oppdatertAktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet, statusText = statusTekst, visLagreKnapp = visLagreKnapp }, Cmd.none, NoSharedMsg )

        EndretAktivitetsOmfangTimer endretOmfangTimer ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | omfangTimer = Just <| Result.withDefault 0 (String.toInt endretOmfangTimer) }

                ( visLagreKnapp, statusTekst ) =
                    valideringsInfo oppdatertAktivitet
            in
                ( { model | aktivitet = oppdatertAktivitet, statusText = statusTekst, visLagreKnapp = visLagreKnapp }, Cmd.none, NoSharedMsg )

        OpprettNyAktivitet ->
            let
                validering =
                    validerAktivitetGyldigNy model.aktivitet

                ( statusTekst, cmd ) =
                    case validering of
                        Ok resultat ->
                            ( "", postOpprettNyAktivitet model.apiEndpoint resultat NyAktivitetRespons )

                        Err feil ->
                            ( feil, Cmd.none )
            in
                ( { model | statusText = statusTekst }, cmd, NoSharedMsg )

        NyAktivitetRespons (Ok nyId) ->
            let
                tmp =
                    Debug.log "ny aktivitet" nyId
            in
                ( model, Cmd.none, NavigateToAktivitet nyId.id )

        NyAktivitetRespons (Err error) ->
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


valideringsInfo : AktivitetEdit -> ( Bool, String )
valideringsInfo aktivitet =
    case validerAktivitetGyldigNy aktivitet of
        Ok _ ->
            ( True, "" )

        Err feil ->
            ( False, feil )


validerAktivitetGyldigNy : AktivitetEdit -> Result String AktivitetGyldigNy
validerAktivitetGyldigNy form =
    Ok AktivitetGyldigNy
        |: notBlank "Navn må fylles ut" form.navn
        |: notBlank "Beskrivelse må fylles ut" form.beskrivelse
        |: required "Timer må fylles ut" form.omfangTimer
        |: required "Velg skole" form.skole
        |: required "Aktivitetstype må velges" form.aktivitetsType


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        (visHeading
            :: visOpprettAktivitet model model.aktivitet
        )


visHeading : Grid.Cell Msg
visHeading =
    cell
        [ size All 12
        ]
        [ Options.span [ Typo.headline ] [ text "Opprett aktivitet" ]
        ]


visOpprettAktivitet : Model -> AktivitetEdit -> List (Grid.Cell Msg)
visOpprettAktivitet model aktivitet =
    [ cell
        [ size All 6
        , Elevation.e0
        , Options.css "padding" "16px 32px"

        -- , Options.css "display" "flex"
        -- , Options.css "flex-direction" "column"
        -- , Options.css "align-items" "left"
        ]
        [ Options.div
            []
            [ Textfield.render Mdl
                [ 1 ]
                model.mdl
                [ Textfield.label "Navn"
                , Textfield.autofocus
                , Textfield.floatingLabel
                , Textfield.text_
                , Textfield.value <| Maybe.withDefault "" aktivitet.navn
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
                , Textfield.rows 4
                , Textfield.value <| Maybe.withDefault "" aktivitet.beskrivelse
                , Options.onInput EndretAktivitetsBeskrivelse
                , cs "text-area"
                ]
                []
            , Options.div [] [ showText p Typo.subhead model.statusText ]
            ]
        ]
    , cell
        [ size All 6
        , Elevation.e0
        , Options.css "padding" "16px 32px"
        ]
        [ Options.div
            []
            [ Textfield.render Mdl
                [ 3 ]
                model.mdl
                [ Textfield.label "Omfang (klokketimer)"
                , Textfield.floatingLabel
                , Textfield.text_
                , Textfield.value <| Maybe.withDefault "0" <| Maybe.map toString aktivitet.omfangTimer
                , Options.onInput EndretAktivitetsOmfangTimer
                ]
                []
            , showText p Typo.menu "Skole"
            , visSkole model aktivitet
            , showText p Typo.menu "Aktivitetstype"
            , visAktivitetstype model aktivitet
            ]
        ]
    , cell
        [ size All 6
        , Elevation.e0
        , Options.css "padding" "16px 32px"
        ]
        [ Button.render Mdl
            [ 10, 1 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.when (not model.visLagreKnapp) Button.disabled
            , Options.onClick (OpprettNyAktivitet)
            , css "float" "left"

            -- , css "margin-left" "1em"
            -- , Options.onClick (SearchAnsatt "Test")
            ]
            [ text "Lagre" ]
        ]
    ]


visSkole : Model -> AktivitetEdit -> Html Msg
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


visAktivitetstype : Model -> AktivitetEdit -> Html Msg
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
