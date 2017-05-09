module Main exposing (..)

import Navigation exposing (Location)
import Html exposing (..)
import Types exposing (..)
import Time exposing (Time)
import RemoteData exposing (RemoteData(..))
import Routing.Router as Router
import Routing.Helpers as RouterHelpers
import Http
import Decoders
import Material.Menu as Menu
import Material
import Material.Progress as Loading
import Material.Options as Options exposing (when, css, cs, Style, onClick)

main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Time.every Time.minute TimeChange
        }


type alias Model =
    { appState : AppState
    , location : Location
    , loadUserRetryCount : Int
    , apiEndpoint : String
    , statusText : String
    }


type AppState
    = NotReady Flags
    | Ready Taco Router.Model


type alias Flags =
    { currentTime : Time
    , apiEndpoint : String
    }


type Msg
    = UrlChange Location
    | TimeChange Time
    | RouterMsg Router.Msg
    | HandleUserInformationResponse (RemoteData.WebData UserInformation)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        endPoint =
            Debug.log "endpoint: " flags.apiEndpoint
    in
        ( { appState = NotReady flags
          , location = location
          , loadUserRetryCount = 0
          , apiEndpoint = flags.apiEndpoint
          , statusText = ""
          }
        , Cmd.batch
            [ fetchUserInformation endPoint
            -- , Cmd.map RouterMsg (Router.getInitialCommand (RouterHelpers.parseLocation location) endPoint)
            ]
        )


fetchUserInformation : String -> Cmd Msg
fetchUserInformation endPoint =
    let
        url =
            endPoint ++ "user"

        req =
            Http.request
                { method = "GET"
                , headers = []
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson Decoders.decodeUserInformation
                , timeout = Nothing
                , withCredentials = True
                }
    in
        req
            |> RemoteData.sendRequest
            |> Cmd.map HandleUserInformationResponse


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeChange time ->
            updateTime model time

        HandleUserInformationResponse webData ->
            updateUserInfo model webData

        UrlChange location ->
            updateRouter { model | location = location } (Router.UrlChange location)

        RouterMsg routerMsg ->
            updateRouter model routerMsg


updateTime : Model -> Time -> ( Model, Cmd Msg )
updateTime model time =
    case model.appState of
        NotReady oldModel ->
            ( { model | appState = NotReady { oldModel | currentTime = time } }
            , Cmd.none
            )

        Ready taco routerModel ->
            ( { model | appState = Ready (updateTaco taco (UpdateTime time)) routerModel }
            , Cmd.none
            )


updateRouter : Model -> Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready taco routerModel ->
            let
                nextTaco =
                    updateTaco taco tacoUpdate

                ( nextRouterModel, routerCmd, tacoUpdate ) =
                    Router.update routerMsg routerModel
            in
                ( { model | appState = Ready nextTaco nextRouterModel }
                , Cmd.map RouterMsg routerCmd
                )

        NotReady _ ->
        let
          tmp = Debug.log "Ooops. We got a sub-component message even though it wasn't supposed to be initialized?" model
        in
          (model, Cmd.none)


updateUserInfo : Model -> RemoteData.WebData UserInformation -> ( Model, Cmd Msg )
updateUserInfo model webData =
    case webData of
        Failure error ->
            let
                (cmd, statusText, retryCount) =
                    case error of
                        Http.BadUrl info ->
                            (Cmd.none, "Feil i url til API", model.loadUserRetryCount)
                        Http.BadPayload _ _ ->
                            (Cmd.none, "Feil i sending av data til API", model.loadUserRetryCount)
                        Http.BadStatus status ->
                            if model.loadUserRetryCount < 5 then
                                (fetchUserInformation model.apiEndpoint, "Prøver henting av data på nytt", model.loadUserRetryCount + 1)
                            else
                                (Cmd.none, "Stoppet henting av data på nytt.", model.loadUserRetryCount)

                        Http.NetworkError ->
                            if model.loadUserRetryCount < 5 then
                                (fetchUserInformation model.apiEndpoint, "Nettverksfeil - Prøver henting av data på nytt", model.loadUserRetryCount + 1)
                            else
                                (Cmd.none, "Stoppet henting av data på nytt.", model.loadUserRetryCount)
                        Http.Timeout ->
                            (Cmd.none, "Nettverksfeil - timet ut", model.loadUserRetryCount)
            in
                ({model | loadUserRetryCount = retryCount}, cmd)


            -- Debug.crash "OMG CANT EVEN DOWNLOAD."

        Success userInfo ->
            case model.appState of
                NotReady notreadyModel ->
                    let
                        initTaco =
                            { currentTime = notreadyModel.currentTime
                            , userInfo = userInfo
                            }

                        ( initRouterModel, routerCmd ) =
                            Router.init model.location notreadyModel.apiEndpoint
                    in
                        ( { model | appState = Ready initTaco initRouterModel }
                        , Cmd.map RouterMsg routerCmd
                        )

                Ready taco routerModel ->
                    ( { model | appState = Ready (updateTaco taco (UpdateUserInfo userInfo)) routerModel }
                    , Cmd.none
                    )

        _ ->
            ( model, Cmd.none )


updateTaco : Taco -> TacoUpdate -> Taco
updateTaco taco tacoUpdate =
    case tacoUpdate of
        UpdateTime time ->
            { taco | currentTime = time }

        UpdateUserInfo userInfo ->
            { taco | userInfo = Debug.log "user" userInfo }

        NoUpdate ->
            taco


view : Model -> Html Msg
view model =
    case model.appState of
        Ready taco routerModel ->
            Router.view taco routerModel
                |> Html.map RouterMsg

        NotReady _ ->
            Options.div
                [ css "display" "flex"
                , css "width" "100%"
                , css "height" "100vh"
                , css "align-items" "center"
                , css "justify-content" "center"
                ]
                [ Loading.indeterminate ]