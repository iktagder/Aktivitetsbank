module Routing.Router exposing (..)

import Material.Snackbar as Snackbar
import Navigation exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (href)
import Types exposing (Route(..), TacoUpdate(..), Taco, SharedMsg(..))
import Routing.Helpers exposing (parseLocation, reverseRoute)
import Pages.Aktiviteter.Aktiviteter as Aktiviteter
import Pages.Aktiviteter.Aktivitet as Aktivitet
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
    """\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .demo-options .mdl-checkbox__box-outline {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      border-color: rgba(255, 255, 255, 0.89);\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
    }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .mdl-layout__drawer {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      border: none !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   .mdl-layout__drawer .mdl-navigation__link:hover {\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      background-color: #00BCD4 !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
      color: #37474F !important;\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
    }\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D\x0D
   """


type alias Model =
    { mdl : Material.Model
    , selectedTab : Int
    , snackbar : Snackbar.Model (Maybe Msg)
    , route : Route
    , aktiviteterModel : Aktiviteter.Model
    , aktivitetModel : Aktivitet.Model
    , apiEndpoint : String
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UrlChange Location
    | NavigateTo Route
    | AktiviteterMsg Aktiviteter.Msg
    | AktivitetMsg Aktivitet.Msg


init : Location -> String -> ( Model, Cmd Msg )
init location apiEndpoint =
    let
        ( aktiviteterModel, aktiviteterCmd ) =
            Aktiviteter.init apiEndpoint

        ( aktivitetModel, aktivitetCmd ) =
            Aktivitet.init apiEndpoint

        route =
            parseLocation location
    in
        ( { mdl = Material.model
          , selectedTab = 0
          , snackbar = Snackbar.model
          , aktiviteterModel = aktiviteterModel
          , route = route
          , aktivitetModel = aktivitetModel
          , apiEndpoint = apiEndpoint
          }
        , Cmd.none
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
                    Snackbar.add (Snackbar.toast Nothing "Url changed") model.snackbar

                route =
                    parseLocation location
            in
                ( { model | route = route, snackbar = snackModel }
                , Cmd.batch
                    [ Cmd.map Snackbar snackCmd
                    , getInitialCommand route model.apiEndpoint
                    ]
                , NoUpdate
                )

        NavigateTo route ->
            ( model
            , Navigation.newUrl (reverseRoute route)
            , NoUpdate
            )

        AktiviteterMsg aktiviteterMsg ->
            updateAktiviteter model aktiviteterMsg

        AktivitetMsg aktivitetMsg ->
            updateAktivitet model aktivitetMsg


getInitialCommand : Route -> String -> Cmd Msg
getInitialCommand route endpoint =
    case route of
        RouteAktivitetsDetalj id ->
            Cmd.map AktivitetMsg <|
                Cmd.batch
                    [ (Aktivitet.hentAktivitetDetalj id endpoint)
                    , Aktivitet.fetchAppMetadata
                        endpoint
                    ]

        RouteAktivitetsListe ->
            Cmd.map AktiviteterMsg <|
                Cmd.batch
                    [ Aktiviteter.fetchAktivitetListe endpoint
                    , Aktiviteter.fetchAppMetadata
                        endpoint
                    ]

        _ ->
            Cmd.none


updateAktiviteter : Model -> Aktiviteter.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateAktiviteter model aktiviteterMsg =
    let
        ( nextAktiviteterModel, aktiviteterCmd, sharedMsg ) =
            Aktiviteter.update aktiviteterMsg model.aktiviteterModel
    in
        ( { model | aktiviteterModel = nextAktiviteterModel }
        , Cmd.map AktiviteterMsg aktiviteterCmd
        , NoUpdate
        )
            |> addSharedMsgToUpdate sharedMsg


updateAktivitet : Model -> Aktivitet.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateAktivitet model aktivitetMsg =
    let
        ( nextAktivitetModel, aktivitetCmd, sharedMsg ) =
            Aktivitet.update aktivitetMsg model.aktivitetModel
    in
        ( { model | aktivitetModel = nextAktivitetModel }
        , Cmd.map AktivitetMsg aktivitetCmd
        , NoUpdate
        )
            |> addSharedMsgToUpdate sharedMsg


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
            , drawer = [ drawerHeader model, viewDrawer model ]
            , tabs =
                ( [], [] )
                -- , tabs = ( tabTitles, [] )
            , main =
                [ pageView taco model
                , Snackbar.view model.snackbar |> map Snackbar
                  -- , Snackbar.view model.snackbar |> App.map Snackbar
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
        [ Layout.title [] [ text "VAF - Telefonskjema" ]
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
    , { text = "Telefonskjema", iconName = "dashboard", route = RouteTelefonskjema }
    , { text = "Ansatt", iconName = "dashboard", route = RouteAnsattPortal }
    , { text = "Tilgangsforespørsler", iconName = "dashboard", route = RouteLederForesporsel }
    , { text = "Tilgangsadministrasjon", iconName = "dashboard", route = RouteTilgangsadministrasjon }
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
    case model.route of
        RouteAktivitetsListe ->
            Aktiviteter.view taco model.aktiviteterModel
                |> Html.map AktiviteterMsg

        RouteAktivitetsDetalj _ ->
            Aktivitet.view taco model.aktivitetModel
                |> Html.map AktivitetMsg

        RouteTelefonskjema ->
            h1 [] [ text "aktivitetsliste" ]

        RouteAnsattPortal ->
            h1 [] [ text "aktivitetsliste" ]

        RouteLederForesporsel ->
            h1 [] [ text "Forespørsel" ]

        RouteTilgangsadministrasjon ->
            h1 [] [ text "Tilgangsadministrasjon" ]

        NotFoundRoute ->
            h1 [] [ text "404 :(" ]


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
