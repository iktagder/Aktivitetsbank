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
    , aktivitet : WebData Aktivitet
    , valgtUtdanningsprogram : Maybe Utdanningsprogram
    , valgtTrinn : Maybe Trinn
    , valgtFag : Maybe Fag
    , deltaker : Deltaker
    , dropdownStateUtdanningsprogram : Dropdown.State
    , dropdownStateTrinn : Dropdown.State
    , dropdownStateFag : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AppMetadataResponse (WebData AppMetadata)
    | AktivitetResponse (WebData Aktivitet)
    | OnSelectUtdanningsprogram (Maybe Utdanningsprogram)
    | OnSelectTrinn (Maybe Trinn)
    | OnSelectFag (Maybe Fag)
    | UtdanningsprogramDropdown (Dropdown.Msg Utdanningsprogram)
    | TrinnDropdown (Dropdown.Msg Trinn)
    | FagDropdown (Dropdown.Msg Fag)
    | EndretKompetansemaal String
    | EndretTimer String
    | OpprettNyDeltaker
    | NyDeltakerRespons (Result Error NyDeltaker)

init : String -> String -> ( Model, Cmd Msg )
init apiEndpoint aktivitetId =
    ( { mdl = Material.model
      , apiEndpoint = apiEndpoint
      , statusText = ""
      , appMetadata = RemoteData.NotAsked
      , aktivitet = RemoteData.NotAsked
      , valgtUtdanningsprogram = Nothing
      , valgtTrinn = Nothing
      , valgtFag = Nothing
      , dropdownStateUtdanningsprogram = Dropdown.newState "1"
      , dropdownStateTrinn = Dropdown.newState "1"
      , dropdownStateFag = Dropdown.newState "1"
      -- , valgtAktivitetstype = Nothing
      -- , dropdownStateAktivitetstype = Dropdown.newState "1"
      , deltaker =
            { id = "0"
            , aktivitetId = Debug.log "aktivitet id: " aktivitetId
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

postOpprettNyDeltaker : String -> String -> Deltaker -> (Result Error NyDeltaker -> msg) -> Cmd msg
postOpprettNyDeltaker endPoint aktivitetId deltaker responseMsg =
    let
        url =
            endPoint ++ "aktiviteter/" ++ aktivitetId ++ "/opprettDeltaker"

        body =
            encodeOpprettNyDeltaker aktivitetId deltaker |> Http.jsonBody

        req =
            Http.request
                { method = "POST"
                , headers = []
                , url = url
                , body = body
                , expect = Http.expectJson decodeNyDeltaker
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

        AktivitetResponse response ->
            ( Debug.log "aktivitet-item-response" { model | aktivitet = response }, Cmd.none, NoSharedMsg )

        OnSelectUtdanningsprogram valg ->
            let
                gammelDeltaker =
                    model.deltaker

                nyId =
                    case valg of
                        Just data ->
                            data.id

                        Nothing ->
                            "00"

                oppdatertDeltaker =
                    { gammelDeltaker | utdanningsprogramId = nyId }
            in
                ( { model | valgtUtdanningsprogram = valg, deltaker = oppdatertDeltaker }, Cmd.none, NoSharedMsg )

        OnSelectTrinn valg ->
            let
                gammelDeltaker =
                    model.deltaker

                nyId =
                    case valg of
                        Just data ->
                            data.id

                        Nothing ->
                            "00"

                oppdatertDeltaker =
                    { gammelDeltaker | trinnId = nyId }
            in
                ( { model | valgtTrinn = valg, deltaker = oppdatertDeltaker }, Cmd.none, NoSharedMsg )

        OnSelectFag valg ->
            let
                gammelDeltaker =
                    model.deltaker

                nyId =
                    case valg of
                        Just data ->
                            data.id

                        Nothing ->
                            "00"

                oppdatertDeltaker =
                    { gammelDeltaker | fagId = nyId }
            in
                ( { model | valgtFag = valg, deltaker = oppdatertDeltaker }, Cmd.none, NoSharedMsg )

        UtdanningsprogramDropdown utdanningsprogram ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigUtdanningsprogram utdanningsprogram model.dropdownStateUtdanningsprogram
            in
                ( { model | dropdownStateUtdanningsprogram = updated }, cmd, NoSharedMsg )

        TrinnDropdown trinn ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigTrinn trinn model.dropdownStateTrinn
            in
                ( { model | dropdownStateTrinn = updated }, cmd, NoSharedMsg )

        FagDropdown fag ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropdownConfigFag fag model.dropdownStateFag
            in
                ( { model | dropdownStateFag = updated }, cmd, NoSharedMsg )

        EndretKompetansemaal endretKompetansemaal ->
            let
                gammelDeltaker =
                    model.deltaker

                oppdatertDeltaker =
                    { gammelDeltaker | kompetansemaal = endretKompetansemaal }
            in
                ( { model | deltaker = oppdatertDeltaker }, Cmd.none, NoSharedMsg )

        EndretTimer endretOmfangTimer ->
            let
                gammelDeltaker =
                    model.deltaker

                oppdatertDeltaker =
                    { gammelDeltaker | timer = Result.withDefault 0 (String.toInt endretOmfangTimer) }
            in
                ( { model | deltaker = oppdatertDeltaker }, Cmd.none, NoSharedMsg )

        OpprettNyDeltaker ->
            let
              cmd =
                case model.aktivitet of
                  Success data ->
                    postOpprettNyDeltaker model.apiEndpoint data.id model.deltaker NyDeltakerRespons
                  _ ->
                    Cmd.none
            in
              ( model, cmd, NoSharedMsg )

        NyDeltakerRespons (Ok nyId) ->
            let
                tmp =
                    Debug.log "ny deltaker" nyId
                cmdShared =
                  case model.aktivitet of
                    Success data ->
                      NavigateToAktivitet data.id
                    _ ->
                    NoSharedMsg
            in
               (model, Cmd.none, cmdShared)

        NyDeltakerRespons (Err error) ->
            let
                tmp =
                    Debug.log "ny deltaker - error" error
            in
                ( model, Cmd.none, NoSharedMsg )

showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


vis : Taco -> Model -> Html Msg
vis taco model =
    grid []
        [ cell
            [ size All 12
            ]
            [ Options.span [ Typo.headline ] [ text "Opprett deltaker" ]
            ]
        , cell
            [ size All 12
            , Elevation.e2
            ]
            [ visOpprettDeltaker model model.deltaker
            ]
        ]

dropdownConfigUtdanningsprogram : Dropdown.Config Msg Utdanningsprogram
dropdownConfigUtdanningsprogram =
    Dropdown.newConfig OnSelectUtdanningsprogram .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg utdanningsprogram"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"

dropdownConfigTrinn : Dropdown.Config Msg Trinn
dropdownConfigTrinn =
    Dropdown.newConfig OnSelectTrinn .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg trinn"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"

dropdownConfigFag : Dropdown.Config Msg Fag
dropdownConfigFag =
    Dropdown.newConfig OnSelectFag .navn
        |> Dropdown.withItemClass "border-bottom border-silver p1 gray"
        |> Dropdown.withMenuClass "border border-gray dropdown"
        |> Dropdown.withMenuStyles [ ( "background", "white" ) ]
        |> Dropdown.withPrompt "Velg fag"
        |> Dropdown.withPromptClass "silver"
        |> Dropdown.withSelectedClass "bold"
        |> Dropdown.withSelectedStyles [ ( "color", "black" ) ]
        |> Dropdown.withTriggerClass "col-4 border bg-white p1"

visOpprettDeltaker : Model -> Deltaker -> Html Msg
visOpprettDeltaker model deltaker =
    Options.div
        []
        [
        --   Textfield.render Mdl
        --     [ 1 ]
        --     model.mdl
        --     [ Textfield.label "Navn"
        --     , Textfield.floatingLabel
        --     , Textfield.text_
        --     , Textfield.value <| aktivitet.navn
        --     , Options.onInput EndretAktivitetsNavn
        --     ]
        --     []
         Textfield.render Mdl
            [ 2 ]
            model.mdl
            [ Textfield.label "Kompetansemål"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.textarea
            , Textfield.rows 5
            , Textfield.value <| deltaker.kompetansemaal
            , Options.onInput EndretKompetansemaal
            , cs "text-area"
            ]
            []
        , Textfield.render Mdl
            [ 3 ]
            model.mdl
            [ Textfield.label "Timer (skoletimer)"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value <| toString deltaker.timer
            , Options.onInput EndretTimer
            ]
            []
        , showText p Typo.menu "Utdanningsprogram"
        , visUtdanningsprogram model
        , showText p Typo.menu "Trinn"
        , visTrinn model
        , showText p Typo.menu "Fag"
        , visFag model
        -- , showText p Typo.menu "Aktivitetstype"
        -- , visAktivitetstype model
        , Button.render Mdl
            [ 10, 1 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.onClick (OpprettNyDeltaker)
            , css "float" "right"
              -- , css "margin-left" "1em"
              -- , Options.onClick (SearchAnsatt "Test")
            ]
            [ text "Lagre" ]
        ]

visUtdanningsprogram : Model -> Html Msg
visUtdanningsprogram model =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visUtdanningsprogramDropdown
                model.valgtUtdanningsprogram
                data.utdanningsprogrammer
                model.dropdownStateUtdanningsprogram


visUtdanningsprogramDropdown : Maybe Utdanningsprogram -> List Utdanningsprogram -> Dropdown.State -> Html Msg
visUtdanningsprogramDropdown selectedUtdanningsprogramId model dropdownStateUtdanningsprogram =
    span []
        [ Html.map UtdanningsprogramDropdown (Dropdown.view dropdownConfigUtdanningsprogram dropdownStateUtdanningsprogram model selectedUtdanningsprogramId)
        ]


visTrinn : Model -> Html Msg
visTrinn model =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visTrinnDropdown
                model.valgtTrinn
                data.trinnListe
                model.dropdownStateTrinn


visTrinnDropdown : Maybe Trinn -> List Trinn -> Dropdown.State -> Html Msg
visTrinnDropdown selectedTrinnId model dropdownStateTrinn =
    span []
        [ Html.map TrinnDropdown (Dropdown.view dropdownConfigTrinn dropdownStateTrinn model selectedTrinnId)
        ]

visFag : Model -> Html Msg
visFag model =
    case model.appMetadata of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            visFagDropdown
                model.valgtFag
                data.fagListe
                model.dropdownStateFag


visFagDropdown : Maybe Fag -> List Fag -> Dropdown.State -> Html Msg
visFagDropdown selectedFagId model dropdownStateFag =
    span []
        [ Html.map FagDropdown (Dropdown.view dropdownConfigFag dropdownStateFag model selectedFagId)
        ]