module Pages.AnsattPortal.AnsattPortal exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Table as Table
import Material.Dialog as Dialog
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Dropdown
import Pages.AnsattPortal.Tilgangstyper as Tilgangstyper exposing (..)
import Pages.AnsattPortal.AnsattTilgangItem as AnsattTilgangItem

styles : String
styles =
    """\x0D\x0D\x0D
   .mdl-layout__drawer {\x0D\x0D\x0D
      border: none !important;\x0D\x0D\x0D
   }\x0D\x0D\x0D
   """


type alias Model =
    { mdl : Material.Model
    , ansattTilganger : WebData (List AnsattTilgangItem.AnsattTilgang)
    , tilgangsTyper : WebData (List Tilgangstyper.TilgangsType)
    , showMoreAnsattProfil : Bool
    , selectedTilgangsTypeId : Maybe Tilgangstyper.TilgangsType
    , dropdownState : Dropdown.State
    }


type Msg
    = Mdl (Material.Msg Msg)
    | AnsattTilgangerResponse (WebData (List AnsattTilgangItem.AnsattTilgang))
    | TilgangsTyperResponse (WebData (List Tilgangstyper.TilgangsType))
    | ShowMoreAnsattProfil
    | TilgangsTyperMsg Tilgangstyper.TilgangsTyperMsg
    | AddSelectedTilgangsType
    | RemoveAnsattTilgang String
    | AddSelectedTilgangsTypeResponse (Result Error AnsattTilgangItem.AnsattTilgang)


init : ( Model, Cmd Msg )
init =
    ( { mdl = Material.model
      , ansattTilganger = RemoteData.NotAsked
      , tilgangsTyper = RemoteData.NotAsked
      , showMoreAnsattProfil = False
      , selectedTilgangsTypeId = Nothing
      , dropdownState = Dropdown.newState "1"
      }
    , Cmd.none
    -- , fetchData
    )


fetchData : Cmd Msg
fetchData =
    Cmd.batch
        [ fetchAnsattTilganger
        , fetchTilgangsTyper
        ]


fetchAnsattTilganger : Cmd Msg
fetchAnsattTilganger =
    Http.get "http://localhost:3004/ansattTilganger" AnsattTilgangItem.decodeAnsattTilgangerList
        |> RemoteData.sendRequest
        |> Cmd.map AnsattTilgangerResponse


fetchTilgangsTyper : Cmd Msg
fetchTilgangsTyper =
    Http.get "http://localhost:3004/tilgangsTyper" decodeTilgangsTyperList
        |> RemoteData.sendRequest
        |> Cmd.map TilgangsTyperResponse



update : Msg -> Model -> ( Model, Cmd Msg, SharedMsg )
update msg model =
    case msg of
        Mdl msg_ ->
          let
            (model_, cmd_ ) =
              Material.update Mdl msg_ model
          in
            (model_, cmd_, NoSharedMsg)

        AnsattTilgangerResponse response ->
            (Debug.log "ansatt" { model | ansattTilganger = response }, Cmd.none, NoSharedMsg)

        TilgangsTyperResponse response ->
            (Debug.log "ansatt" { model | tilgangsTyper = response }, Cmd.none, NoSharedMsg )

        ShowMoreAnsattProfil ->
            ({ model | showMoreAnsattProfil = not model.showMoreAnsattProfil }, Cmd.none, CreateSnackbarToast "Går til ansattprofil")

        TilgangsTyperMsg tilgangstypeMsg ->
            case tilgangstypeMsg of
                OnSelect tilgang ->
                    ( { model | selectedTilgangsTypeId = tilgang }, Cmd.none, NoSharedMsg )

                DropdownMsg subMsg ->
                    let
                        ( updated, cmd ) =
                            Dropdown.update dropdownConfig subMsg model.dropdownState
                    in
                        ( { model | dropdownState = updated }, Cmd.map TilgangsTyperMsg cmd, NoSharedMsg )

        AddSelectedTilgangsType ->
            let
                newCmd =
                    case model.selectedTilgangsTypeId of
                        Just tilgang ->
                            AnsattTilgangItem.postNewAnsattTilgang (AnsattTilgangItem.NyAnsattTilgang tilgang.navn tilgang.beskrivelse) AddSelectedTilgangsTypeResponse

                        Nothing ->
                            --Vise feilmelding?
                            Cmd.none
            in
                ( { model | selectedTilgangsTypeId = Nothing }, newCmd, NoSharedMsg )

        RemoveAnsattTilgang id ->
            let
                a =
                    Debug.log "RemoveAnsattTilgang" id
            in
                ( model, Cmd.none, CreateSnackbarToast "Forespørsel om fjerning av tilgang er sendt" )

        AddSelectedTilgangsTypeResponse (Ok tilgang) ->
            let
                result =
                    case model.ansattTilganger of
                        Success ansattTilganger_ ->
                            RemoteData.succeed <| tilgang :: ansattTilganger_

                        _ ->
                            model.ansattTilganger
            in
                ( { model | ansattTilganger = result }, Cmd.none, CreateSnackbarToast "La til tilgangstype" )

        AddSelectedTilgangsTypeResponse (Err error) ->
            let
                errorText =
                    case error of
                        Http.BadUrl message ->
                            "Bad url " ++ message

                        Http.Timeout ->
                            "Timeout"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus _ ->
                            "Bad status : "

                        Http.BadPayload _ _ ->
                            "Bad Payload "
            in
                ( model
                , Cmd.none
                , CreateSnackbarToast errorText
                )


view : Taco -> Model -> Html Msg
view taco model =
    let
        pieClass =
            "abc123"
    in
        grid [ Options.css "max-width" "1280px" ]
            [ cell
                [ size All 8
                , Elevation.e0
                , Options.css "align-items" "top"
                , Options.cs "mdl-grid"
                ]
                [ Options.styled p [ Typo.display2 ] [ text "Atle Johannesen" ]
                ]
            , cell
                [ size All 4
                , Elevation.e2
                , Options.css "align-items" "left"
                , Options.css "display" "flex"
                , Options.css "flex-direction" "column"
                , Options.cs "mdl-grid"
                ]
                (viewAnsattInfo model)
            , cell
                [ size All 12
                , Elevation.e2
                , Options.css "padding" "16px 32px"
                , Options.css "display" "flex"
                , Options.css "flex-direction" "column"
                , Options.css "align-items" "left"
                ]
                [ showText p Typo.headline "Tilganger"
                , viewAnsattTilganger model
                ]
            , cell
                [ size All 12
                , Elevation.e0
                , Options.css "padding" "16px 32px"
                , Options.css "display" "flex"
                , Options.css "flex-direction" "column"
                , Options.css "align-items" "left"
                ]
                [ viewAddNewTilgangsType model
                ]
            ]


viewAnsattInfo : Model -> List (Html Msg)
viewAnsattInfo model =
    [ Options.styled p [ Typo.body2 ] [ text "Arbeidssted: IT seksjonen" ]
    , Options.styled p [ Typo.body2 ] [ text "Tittel: IT konsulent" ]
    , showText p Typo.body2 "Nærmeste leder: Knut Fredvik"
    , Button.render Mdl
        [ 0 ]
        model.mdl
        [ Button.ripple
        , Button.colored
        , Button.raised
          -- , Button.link "#grid"
        -- , Options.onClick (ShowMoreAnsattProfil)
        , Dialog.openOn "click"
        ]
        [ text "Vis/endre ansattprofil" ]
    , if model.showMoreAnsattProfil then
        showText p Typo.body2 "Ekstra info.."
      else
        span [] []
    ]


showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


white : Options.Property a b
white =
    Color.text Color.white


viewAnsattTilganger : Model -> Html Msg
viewAnsattTilganger model =
    case model.ansattTilganger of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success data ->
            viewAnsattTilgangerSuccess model data



viewAnsattTilgangerSuccess : Model -> List AnsattTilgangItem.AnsattTilgang -> Html Msg
viewAnsattTilgangerSuccess model data =
    Table.table [ css "table-layout" "fixed", css "width" "100%" ]
        -- Table.table [css "table-layout" "fixed", css "width" "100%"]
        [ Table.thead
            []
            [ Table.tr []
                [ Table.th
                    [ css "width" "20%" ]
                    [ showText div Typo.body2 "Tilgang"
                    ]
                , Table.th [ css "width" "70%" ]
                    [ showText div Typo.body2 "Beskrivelse"
                    ]
                , Table.th [ css "width" "10%" ]
                    [ showText span Typo.body2 "Aksjon"
                    ]
                ]
            ]
        , Table.tbody []
            (data
                |> List.sortBy .navn
                |> List.indexedMap (\idx item -> AnsattTilgangItem.viewAnsattTilgang idx item model.mdl Mdl RemoveAnsattTilgang)
            )
        ]

viewAddNewTilgangsType : Model -> Html Msg
viewAddNewTilgangsType model =
    div []
        [ Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.onClick (AddSelectedTilgangsType)
            ]
            [ text "Legg til" ]
        , Html.map TilgangsTyperMsg <| viewTilgangsTyper model.tilgangsTyper model.selectedTilgangsTypeId model.dropdownState
        ]
