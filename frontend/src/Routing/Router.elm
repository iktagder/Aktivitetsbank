module Routing.Router exposing (..)

import Material.Snackbar as Snackbar
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Navigation exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (href)
import Types exposing (Route(..), TacoUpdate(..), Taco, SharedMsg(..))
import Routing.Helpers exposing (parseLocation, reverseRoute)
import Pages.Aktiviteter.Aktiviteter as Aktiviteter
import Pages.Aktiviteter.Aktivitet as Aktivitet
import Pages.Aktiviteter.AktivitetOpprett as AktivitetOpprett
import Pages.Aktiviteter.DeltakerOpprett as DeltakerOpprett
import Material
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Icon as Icon
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Options as Options exposing (css, cs, when)


styles : String
styles =
    """\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .demo-options .mdl-checkbox__box-outline {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      border-color: rgba(255, 255, 255, 0.89);\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
    }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .mdl-layout__drawer {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      border: none !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .mdl-layout__drawer .mdl-navigation__link:hover {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      background-color: #00BCD4 !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      color: #37474F !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
    }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   """


type Page
    = AktiviteterPage Aktiviteter.Model
    | AktivitetPage Aktivitet.Model
    | AktivitetOpprettPage AktivitetOpprett.Model
    | DeltakerOpprettPage DeltakerOpprett.Model
    | NotFoundPage


type alias Model =
    { mdl : Material.Model
    , selectedTab : Int
    , snackbar : Snackbar.Model (Maybe Msg)
    , route : Route
    , currentPage : Page
    , apiEndpoint : String
    }


type PageMsg
    = AktiviteterMsg Aktiviteter.Msg
    | AktivitetMsg Aktivitet.Msg
    | AktivitetOpprettMsg AktivitetOpprett.Msg
    | DeltakerOpprettMsg DeltakerOpprett.Msg


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UrlChange Location
    | NavigateTo Route
    | PagesMsg PageMsg


init : Location -> String -> ( Model, Cmd Msg )
init location apiEndpoint =
    let
        route =
            parseLocation location

        ( pageModel, pageCmd ) =
            urlUpdate apiEndpoint route
    in
        ( { mdl = Material.model
          , selectedTab = 0
          , snackbar = Snackbar.model
          , route = route
          , currentPage = pageModel
          , apiEndpoint = apiEndpoint
          }
        , pageCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
update msg model =
    case msg of
        Mdl msg_ ->
            let
                ( mdlModel, mdlCmd ) =
                    Material.update Mdl msg_ model
            in
                ( mdlModel, mdlCmd, NoUpdate )

        Snackbar msg_ ->
            let
                ( snackbar, snackCmd ) =
                    Snackbar.update msg_ model.snackbar
            in
                ( { model | snackbar = snackbar }, Cmd.map Snackbar snackCmd, NoUpdate )

        UrlChange location ->
            let
                ( snackModel, snackCmd ) =
                    Snackbar.add (Snackbar.toast Nothing "Endret url") model.snackbar

                route =
                    parseLocation location

                ( pageModel, pageCmd ) =
                    urlUpdate model.apiEndpoint route
            in
                ( { model | route = route, currentPage = pageModel, snackbar = snackModel }
                , Cmd.batch
                    [ Cmd.map Snackbar snackCmd
                    , pageCmd
                    ]
                , NoUpdate
                )

        NavigateTo route ->
            ( model
            , Navigation.newUrl (reverseRoute route)
            , NoUpdate
            )

        PagesMsg pageMsg ->
            updatePage model pageMsg


urlUpdate : String -> Route -> ( Page, Cmd Msg )
urlUpdate apiEndpoint route =
    let
        ( pageModel, pageCmd ) =
            case route of
                RouteAktivitetsDetalj id ->
                    let
                        ( model_, cmd_ ) =
                            Aktivitet.init apiEndpoint id
                    in
                        ( AktivitetPage model_, Cmd.map AktivitetMsg cmd_ )

                RouteAktivitetsListe ->
                    let
                        ( model_, cmd_ ) =
                            Aktiviteter.init apiEndpoint
                    in
                        ( AktiviteterPage model_, Cmd.map AktiviteterMsg cmd_ )

                RouteAktivitetOpprett ->
                    let
                        ( model_, cmd_ ) =
                            AktivitetOpprett.init apiEndpoint
                    in
                        ( AktivitetOpprettPage model_, Cmd.map AktivitetOpprettMsg cmd_ )

                RouteDeltakerOpprett id ->
                    let
                        ( model_, cmd_ ) =
                            DeltakerOpprett.init apiEndpoint id
                    in
                        ( DeltakerOpprettPage model_, Cmd.map DeltakerOpprettMsg cmd_ )

                _ ->
                    ( NotFoundPage, Cmd.none )
    in
        ( pageModel, Cmd.map PagesMsg pageCmd )


updatePage : Model -> PageMsg -> ( Model, Cmd Msg, TacoUpdate )
updatePage model msg =
    let
        ( newPageModel, pageMsg, sharedMsg ) =
            case msg of
                AktiviteterMsg msg_ ->
                    case model.currentPage of
                        AktiviteterPage pageModel ->
                            updateAktiviteter model pageModel msg_

                        _ ->
                            ( model.currentPage, Cmd.none, NoSharedMsg )

                AktivitetMsg msg_ ->
                    case model.currentPage of
                        AktivitetPage pageModel ->
                            updateAktivitet model pageModel msg_

                        _ ->
                            ( model.currentPage, Cmd.none, NoSharedMsg )

                AktivitetOpprettMsg msg_ ->
                    case model.currentPage of
                        AktivitetOpprettPage pageModel ->
                            updateAktivitetOpprett model pageModel msg_

                        _ ->
                            ( model.currentPage, Cmd.none, NoSharedMsg )

                DeltakerOpprettMsg msg_ ->
                    case model.currentPage of
                        DeltakerOpprettPage pageModel ->
                            updateDeltakerOpprett model pageModel msg_

                        _ ->
                            ( model.currentPage, Cmd.none, NoSharedMsg )
    in
        ( { model | currentPage = newPageModel }, Cmd.map PagesMsg pageMsg, NoUpdate )
            |> addSharedMsgToUpdate sharedMsg


updateAktiviteter : Model -> Aktiviteter.Model -> Aktiviteter.Msg -> ( Page, Cmd PageMsg, SharedMsg )
updateAktiviteter model aktiviteterModel aktiviteterMsg =
    let
        ( nextAktiviteterModel, aktiviteterCmd, sharedMsg ) =
            Aktiviteter.update aktiviteterMsg aktiviteterModel
    in
        ( AktiviteterPage nextAktiviteterModel
        , Cmd.map AktiviteterMsg aktiviteterCmd
        , sharedMsg
        )


updateAktivitet : Model -> Aktivitet.Model -> Aktivitet.Msg -> ( Page, Cmd PageMsg, SharedMsg )
updateAktivitet model aktivitetModel aktivitetMsg =
    let
        ( nextAktivitetModel, aktivitetCmd, sharedMsg ) =
            Aktivitet.update aktivitetMsg aktivitetModel
    in
        ( AktivitetPage nextAktivitetModel
        , Cmd.map AktivitetMsg aktivitetCmd
        , sharedMsg
        )


updateAktivitetOpprett : Model -> AktivitetOpprett.Model -> AktivitetOpprett.Msg -> ( Page, Cmd PageMsg, SharedMsg )
updateAktivitetOpprett model aktivitetOpprettModel aktivitetOpprettMsg =
    let
        ( nextAktivitetOpprettModel, aktivitetOpprettCmd, sharedMsg ) =
            AktivitetOpprett.update aktivitetOpprettMsg aktivitetOpprettModel
    in
        ( AktivitetOpprettPage nextAktivitetOpprettModel
        , Cmd.map AktivitetOpprettMsg aktivitetOpprettCmd
        , sharedMsg
        )


updateDeltakerOpprett : Model -> DeltakerOpprett.Model -> DeltakerOpprett.Msg -> ( Page, Cmd PageMsg, SharedMsg )
updateDeltakerOpprett model deltakerOpprettModel deltakerOpprettMsg =
    let
        ( nextDeltakerOpprettModel, deltakerOpprettCmd, sharedMsg ) =
            DeltakerOpprett.update deltakerOpprettMsg deltakerOpprettModel
    in
        ( DeltakerOpprettPage nextDeltakerOpprettModel
        , Cmd.map DeltakerOpprettMsg deltakerOpprettCmd
        , sharedMsg
        )


addSharedMsgToUpdate : SharedMsg -> ( Model, Cmd Msg, TacoUpdate ) -> ( Model, Cmd Msg, TacoUpdate )
addSharedMsgToUpdate sharedMsg ( model, msg, tacoUpdate ) =
    case sharedMsg of
        CreateSnackbarToast toastMessage ->
            let
                ( snackModel, snackCmd ) =
                    Snackbar.add (Snackbar.toast Nothing toastMessage) model.snackbar
            in
                ( { model | snackbar = snackModel }
                , Cmd.batch
                    [ Cmd.map Snackbar snackCmd
                    , msg
                    ]
                , tacoUpdate
                )

        NavigateToAktivitet id ->
            ( model, Navigation.newUrl <| reverseRoute (RouteAktivitetsDetalj id), tacoUpdate )

        NavigerTilAktivitetOpprett ->
            ( model, Navigation.newUrl <| reverseRoute RouteAktivitetOpprett, tacoUpdate )

        NavigerTilDeltakerOpprett id ->
            ( model, Navigation.newUrl <| reverseRoute (RouteDeltakerOpprett id), tacoUpdate )

        NavigerTilHjem ->
            ( model, Navigation.newUrl <| reverseRoute (RouteAktivitetsListe), tacoUpdate )

        NoSharedMsg ->
            ( model, msg, tacoUpdate )


view : Taco -> Model -> Html Msg
view taco model =
    div [] <|
        [ Options.stylesheet styles
        , Layout.render Mdl
            model.mdl
            [ Layout.selectedTab model.selectedTab
            , Layout.fixedHeader
            , Options.css "display" "flex !important"
            , Options.css "flex-direction" "row"
            , Options.css "align-items" "center"
            ]
            { header = [ viewHeader taco model ]
            , drawer = []
            , tabs =
                ( [], [] )
            , main =
                [ pageView taco model
                , Snackbar.view model.snackbar |> map Snackbar
                ]
            }
        , helpDialog model
        ]


viewHeader : Taco -> Model -> Html Msg
viewHeader taco model =
    Layout.row
        [ Color.background <| Color.color Color.Grey Color.S100
        , Color.text <| Color.color Color.Grey Color.S900
        ]
        [ Layout.title [ Options.onClick (NavigateTo RouteAktivitetsListe), cs "vis-navigering" ] [ text "VAF - Aktivitetsbank" ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link
                []
                [ span [] [ text taco.userInfo.brukerNavn ] ]
            ]
        ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Types.Route
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Aktivitetsliste", iconName = "dashboard", route = RouteAktivitetsListe }
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html Msg
viewDrawerMenuItem model menuItem =
    Layout.link
        [ Options.onClick (NavigateTo menuItem.route)
        , when ((model.route) == menuItem.route) (Color.background <| Color.color Color.BlueGrey Color.S600)
        , Options.css "color" "rgba(255, 255, 255, 0.56)"
        , Options.css "font-weight" "500"
        ]
        [ Icon.view menuItem.iconName
            [ Color.text <| Color.color Color.BlueGrey Color.S500
            , Options.css "margin-right" "32px"
            ]
        , text menuItem.text
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    Layout.navigation
        [ Color.background <| Color.color Color.BlueGrey Color.S800
        , Color.text <| Color.color Color.BlueGrey Color.S50
        , Options.css "flex-grow" "1"
        ]
    <|
        (List.map (viewDrawerMenuItem model) menuItems)


drawerHeader : Model -> Html Msg
drawerHeader model =
    Options.styled Html.header
        [ css "display" "flex"
        , css "box-sizing" "border-box"
        , css "justify-content" "flex-end"
        , css "padding" "16px"
        , css "height" "151px"
        , css "flex-direction" "column"
        , cs "demo-header"
        , Color.background <| Color.color Color.BlueGrey Color.S900
        , Color.text <| Color.color Color.BlueGrey Color.S50
        ]
        [ Options.styled Html.img
            [ Options.attribute <| Html.Attributes.src "images/elm.png"
            , css "width" "48px"
            , css "height" "48px"
            , css "border-radius" "24px"
            ]
            []
        , Options.styled Html.div
            [ css "display" "flex"
            , css "flex-direction" "row"
            , css "align-items" "center"
            , css "width" "100%"
            , css "position" "relative"
            ]
            [ Layout.spacer
            ]
        ]


pageView : Taco -> Model -> Html Msg
pageView taco model =
    let
        view =
            case model.currentPage of
                AktiviteterPage pageModel ->
                    Aktiviteter.view taco pageModel
                        |> Html.map AktiviteterMsg

                AktivitetPage pageModel ->
                    Aktivitet.view taco pageModel
                        |> Html.map AktivitetMsg

                AktivitetOpprettPage pageModel ->
                    AktivitetOpprett.view taco pageModel
                        |> Html.map AktivitetOpprettMsg

                DeltakerOpprettPage pageModel ->
                    DeltakerOpprett.vis taco pageModel
                        |> Html.map DeltakerOpprettMsg

                _ ->
                    h1 [] [ text "404 :(" ]
    in
        view
            |> Html.map PagesMsg


helpDialog : Model -> Html Msg
helpDialog model =
    Dialog.view
        []
        [ Dialog.title [] [ text "About" ]
        , Dialog.content []
            [ Html.p []
                [ text "Eksempel på dialogboks" ]
            , Html.p []
                [ text "Ansattprofil skal linkes til en annen side" ]
            ]
        , Dialog.actions []
            [ Options.styled Html.span
                [ Dialog.closeOn "click" ]
                [ Button.render Mdl
                    [ 5, 1, 6 ]
                    model.mdl
                    [ Button.ripple
                    ]
                    [ text "Aktiviteter" ]
                ]
            ]
        ]
