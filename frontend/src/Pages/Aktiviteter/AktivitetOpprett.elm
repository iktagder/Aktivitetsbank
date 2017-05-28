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
    , aktivitet : AktivitetEdit
    , dropdownStateSkole : Dropdown.State
    , dropdownStateSkoleAar : Dropdown.State
    , dropdownStateAktivitetstype : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | OnSelectSkole (Maybe Skole)
    | OnSelectSkoleAar (Maybe SkoleAar)
    | SkoleDropdown (Dropdown.Msg Skole)
    | SkoleAarDropdown (Dropdown.Msg SkoleAar)
    | OnSelectAktivitetstype (Maybe AktivitetsType)
    | AktivitetstypeDropdown (Dropdown.Msg AktivitetsType)
    | EndretAktivitetsNavn String
    | EndretAktivitetsBeskrivelse String
    | EndretAktivitetsOmfangTimer String
    | OpprettNyAktivitet
    | NyAktivitetRespons (Result Error NyAktivitet)
    | NavigerHjem


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , visLagreKnapp = False
      , dropdownStateSkole = Dropdown.newState "1"
      , dropdownStateSkoleAar = Dropdown.newState "1"
      , dropdownStateAktivitetstype = Dropdown.newState "1"
      , aktivitet = initAktivitet
      }
    , Cmd.none
    )


initAktivitet : AktivitetEdit
initAktivitet =
    { id = Nothing
    , navn = Nothing
    , beskrivelse = Nothing
    , omfangTimer = Nothing
    , skole = Nothing
    , aktivitetsType = Nothing
    , skoleAar = Nothing
    }


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

        OnSelectSkoleAar skoleAar ->
            let
                gammelAktivitet =
                    model.aktivitet

                oppdatertAktivitet =
                    { gammelAktivitet | skoleAar = skoleAar }

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

        SkoleAarDropdown skoleAar ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigSkoleAar skoleAar model.dropdownStateSkoleAar
            in
                ( { model | dropdownStateSkoleAar = updated }, cmd, NoSharedMsg )

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

        NavigerHjem ->
            ( model, Cmd.none, NavigerTilHjem )


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
        |: required "Skoleår må velges" form.skoleAar


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


view : Taco -> Model -> Html Msg
view taco model =
    grid []
        (visHeading
            :: visOpprettAktivitet model taco model.aktivitet
        )


visHeading : Grid.Cell Msg
visHeading =
    cell
        [ size All 12
        ]
        [ Options.span
            [ Typo.headline
            , Options.css "padding" "16px 32px"
            ]
            [ text "Opprett aktivitet" ]
        ]


visOpprettAktivitet : Model -> Taco -> AktivitetEdit -> List (Grid.Cell Msg)
visOpprettAktivitet model taco aktivitet =
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
            , Textfield.render Mdl
                [ 3 ]
                model.mdl
                [ Textfield.label "Omfang (klokketimer)"
                , Textfield.floatingLabel
                , Textfield.text_
                , Textfield.value <| Maybe.withDefault "0" <| Maybe.map toString aktivitet.omfangTimer
                , Options.onInput EndretAktivitetsOmfangTimer
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
            [ showText p Typo.menu "Skole"
            , visSkole model taco aktivitet
            , showText p Typo.menu "Aktivitetstype"
            , visAktivitetstype model taco aktivitet
            , showText p Typo.menu "Skoleår"
            , visSkoleAar model taco aktivitet
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
            , Options.onClick (NavigerHjem)
            , css "float" "left"
            , Options.css "margin" "6px 6px"
            ]
            [ text "Avbryt" ]
        , Button.render Mdl
            [ 10, 104 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.when (not model.visLagreKnapp) Button.disabled
            , Options.onClick (OpprettNyAktivitet)
            , css "float" "left"
            , Options.css "margin" "6px 6px"

            -- , css "margin-left" "1em"
            -- , Options.onClick (SearchAnsatt "Test")
            ]
            [ text "Lagre" ]
        ]
    ]


visSkole : Model -> Taco -> AktivitetEdit -> Html Msg
visSkole model taco aktivitet =
    span []
        [ Html.map SkoleDropdown (Dropdown.view dropdownConfigSkole model.dropdownStateSkole taco.appMetadata.skoler aktivitet.skole)
        ]


visAktivitetstype : Model -> Taco -> AktivitetEdit -> Html Msg
visAktivitetstype model taco aktivitet =
    span []
        [ Html.map AktivitetstypeDropdown (Dropdown.view dropdownConfigAktivitetstype model.dropdownStateAktivitetstype taco.appMetadata.aktivitetstyper aktivitet.aktivitetsType)
        ]


visSkoleAar : Model -> Taco -> AktivitetEdit -> Html Msg
visSkoleAar model taco aktivitet =
    span []
        [ Html.map SkoleAarDropdown (Dropdown.view dropdownConfigSkoleAar model.dropdownStateSkoleAar taco.appMetadata.skoleAar aktivitet.skoleAar)
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


dropdownConfigSkoleAar : Dropdown.Config Msg SkoleAar
dropdownConfigSkoleAar =
    Dropdown.newConfig OnSelectSkoleAar .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg skoleår"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"
