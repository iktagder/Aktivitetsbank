
module Pages.Telefonskjema.Telefonskjema exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Textfield as Textfield
import Material.List as Lists
import Material.Spinner as Loading
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Http exposing (Error)
import Decoders exposing (..)

type Stage
    = SearchInput
    | SearchResults
    | ChangeTelefon

type alias Model =
    { mdl : Material.Model
    , stage : Stage
    , apiEndpoint : String
    , enableEdit : Bool
    , updating : Bool
    , statusText : String
    , searchAnsattResponse : WebData (List AnsattSearchItem)
    , ansattResponse : WebData AnsattItem
    }



type Msg
    = Mdl (Material.Msg Msg)
    | SearchAnsatt String
    | SearchAnsattResponse (WebData (List AnsattSearchItem))
    | SelectAnsatt String
    | AnsattResponse (WebData AnsattItem)
    | CancelChangeTelefonnummer
    | UpdateAnsattPhone String
    | PerformChangeTelefonnummer
    | PerformChangeTelefonnummerResponse (Result Error ())
    | FinishedChangeTelefonnummer


init : String -> ( Model, Cmd Msg )
init apiEndpoint =
    ( { mdl = Material.model
      , stage = SearchInput
      , apiEndpoint = apiEndpoint
      , enableEdit = True
      , updating = False
      , statusText = ""
      , searchAnsattResponse = RemoteData.NotAsked
      , ansattResponse = RemoteData.NotAsked
      }
    , Cmd.none
    )

fetchSearchAnsatt : String -> String -> Cmd Msg
fetchSearchAnsatt endPoint searchQuery =
    let
      queryUrl =
        endPoint ++ "searchemployees/" ++ searchQuery
      req =  Http.request
        { method = "GET"
        , headers = []
        , url = queryUrl
        , body = Http.emptyBody
        , expect = Http.expectJson Decoders.decodeSearchAnsattList
        , timeout = Nothing
        , withCredentials = True
        }
    in
        req
        |> RemoteData.sendRequest
        |> Cmd.map SearchAnsattResponse

fetchAnsatt : String -> String -> Cmd Msg
fetchAnsatt endPoint ansatt =
    let
      queryUrl =
        endPoint ++ "employees/" ++ ansatt
      req =  Http.request
        { method = "GET"
        , headers = []
        , url = queryUrl
        , body = Http.emptyBody
        , expect = Http.expectJson Decoders.decodeAnsattItem
        , timeout = Nothing
        , withCredentials = True
        }
    in
        req
        |> RemoteData.sendRequest
        |> Cmd.map AnsattResponse

postChangePhoneNumber : String -> AnsattItem -> ((Result Error ()) -> msg) -> Cmd msg
postChangePhoneNumber endPoint ansatt responseMsg =
    let
        url =
            endPoint ++ "employees/" ++ ansatt.agressoResourceId ++ "/changephone"

        body =
            encodeChangePhoneNumber ansatt |> Http.jsonBody

        req =
            Http.request
                { method = "POST"
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
            (model_, cmd_ ) =
              Material.update Mdl msg_ model
          in
            (model_, cmd_, NoSharedMsg)

        SearchAnsatt input ->
          let
            (searchModel, searchCommand) =
              if String.length input >= 4 then
                    ({model | stage = SearchResults, searchAnsattResponse = Loading}, fetchSearchAnsatt model.apiEndpoint input)
              else
                  ({model | stage = SearchResults, searchAnsattResponse = NotAsked }, Cmd.none)
          in
            (searchModel, searchCommand, NoSharedMsg)

        SearchAnsattResponse response ->
            (Debug.log "ansatt-search" { model | searchAnsattResponse = response }, Cmd.none, NoSharedMsg)


        SelectAnsatt input ->
          (model, fetchAnsatt model.apiEndpoint input, NoSharedMsg)

        AnsattResponse response ->
            (Debug.log "ansatt-response" { model | ansattResponse = response, stage = ChangeTelefon }, Cmd.none, NoSharedMsg)


        CancelChangeTelefonnummer ->
          ({model | stage = SearchResults}, Cmd.none, NoSharedMsg)

        UpdateAnsattPhone input ->
          let
            newAnsattResponse =
              case model.ansattResponse of
                Success data ->
                  let
                    updatedPhoneData = {data | phoneNumber = Just input}
                  in
                    RemoteData.Success updatedPhoneData
                _ ->
                  model.ansattResponse
          in
            ({model | ansattResponse = newAnsattResponse}, Cmd.none, NoSharedMsg)

        FinishedChangeTelefonnummer ->
          ({model | enableEdit = True, stage = SearchInput, statusText = ""}, Cmd.none, NoSharedMsg)

        PerformChangeTelefonnummerResponse (Ok _) ->
          ({model | enableEdit = False, updating = False}, Cmd.none, NoSharedMsg)

        PerformChangeTelefonnummerResponse (Err error) ->
          let
              log = Debug.log "Feil i nettverk" error
          in
            ({model | enableEdit = False, updating = False, statusText = "Nettverkstrafikk feilet"}, Cmd.none, NoSharedMsg)

        PerformChangeTelefonnummer ->
          let
            (updateModel, cmd) =
              case model.ansattResponse of
                Success data ->
                  ({model | updating = True}, postChangePhoneNumber model.apiEndpoint data PerformChangeTelefonnummerResponse)
                _ ->
                  ({model | updating = False}, Cmd.none)
          in

          (updateModel, cmd, NoSharedMsg)

view : Taco -> Model -> Html Msg
view taco model =
        grid [ Options.css "max-width" "1280px" ]
            [ cell
                [ size All 12
                , Elevation.e0
                , Options.css "align-items" "top"
                , Options.cs "mdl-grid"
                ]
                [ Options.styled p [ Typo.display2 ] [ text "Telefonskjema" ]
                ]
            , cell
                [ size All 12
                , Elevation.e2
                , Options.css "padding" "16px 32px"
                , Options.css "display" "flex"
                , Options.css "flex-direction" "column"
                , Options.css "align-items" "left"
                ]
                [ viewMainContent model
                ]
            ]

viewMainContent : Model -> Html Msg
viewMainContent model =
    case model.stage of
        SearchInput ->
          div [][ showText p Typo.headline "Søk etter ansatt"
                , viewSearchInput model
                ]
        SearchResults ->
          div [][ showText p Typo.headline "Søk etter ansatt"
                , viewSearchInput model
                , viewSearchResults model
                ]
        ChangeTelefon ->
          div [][ viewChangeTelefonnummer model
                ]
showText : (List (Html.Attribute m) -> List (Html msg) -> a) -> Options.Property c m -> String -> a
showText elementType displayStyle text_ =
    Options.styled elementType [ displayStyle, Typo.left ] [ text text_ ]


white : Options.Property a b
white =
    Color.text Color.white

viewSearchInput : Model -> Html Msg
viewSearchInput model =
    div [][
    Textfield.render Mdl [2] model.mdl
      [ Textfield.label "Fyll inn AD brukernavn"
      , Textfield.floatingLabel
      , Textfield.text_
      , Textfield.autofocus
      , Options.onInput (SearchAnsatt)
      ]
      []
    ]

viewSearchResults : Model -> Html Msg
viewSearchResults model =
    case model.searchAnsattResponse of
        NotAsked ->
            text "Skriv 4 bokstaver eller mer.."

        Loading ->
            Options.div [] [
            Loading.spinner [ Loading.active True]
            ]
            -- Options.div [css "width" "30%"][Loading.indeterminate]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            viewSearchResultsSuccess model data


viewSearchResultsSuccess : Model -> List AnsattSearchItem -> Html Msg
viewSearchResultsSuccess model ansattSearch =
        Lists.ul [css "width" "60%"]

            (ansattSearch
            |> List.map (viewAnsattSearchResultItem model)
            )


viewAnsattSearchResultItem : Model -> AnsattSearchItem -> Html Msg
viewAnsattSearchResultItem model item =
    let
      selectButton model k ansattId =
            Button.render Mdl [k] model.mdl
              [ Button.raised
              -- , Button.accent |> when (Set.member k model.toggles)
              , Options.onClick (SelectAnsatt ansattId)
              ]
              [ text "Velg" ]
    in
      Lists.li [ Lists.withSubtitle ] -- NB! Required on every Lists.li containing subtitle.
          [ Lists.content []
              [ text (item.fornavn ++ " " ++ item.etternavn)
              , Lists.subtitle [] [ text <| (Maybe.withDefault "(tomt)" item.agressoResourceId) ]
              ]
            , selectButton model 5 item.ansattId
          ]


viewChangeTelefonnummer : Model -> Html Msg
viewChangeTelefonnummer model =
    case model.ansattResponse of
        NotAsked ->
            text "Ingen forespørsel om ansatt"

        Loading ->
            text "Henter..."

        Failure err ->
            text ("Feil ved henting av ansatt")

        Success data ->
            viewChangeTelefonnummerSuccess model data

viewChangeTelefonnummerSuccess : Model -> AnsattItem-> Html Msg
viewChangeTelefonnummerSuccess model ansatt =
    div [][ viewAnsattInfo model ansatt
          , viewTelefonInput model ansatt
          , viewChangeTelefonnummerButtons model ansatt
          , viewChangeTelefonnummerStatus model
          ]

viewChangeTelefonnummerButtons : Model -> AnsattItem -> Html Msg
viewChangeTelefonnummerButtons model ansatt =
    case model.enableEdit of
        True ->
          case model.updating of
              True ->
                  Options.div [] [
                  Loading.spinner [ Loading.active True]
                  ]

              False ->
                div [][Button.render Mdl
                          [ 10, 1 ]
                          model.mdl
                          [ Button.ripple
                          , Button.colored
                          , Button.raised
                          , Options.onClick (PerformChangeTelefonnummer)
                          -- , css "margin-left" "1em"
                          -- , Options.onClick (SearchAnsatt "Test")
                          ]
                          [ text "Lagre telefonnummer til Agresso og AD" ]
                      , Button.render Mdl
                          [ 10, 2 ]
                          model.mdl
                          [ Button.ripple
                          -- , Button.colored
                          , Button.raised
                          , css "margin-left" "1em"
                          , Options.onClick (CancelChangeTelefonnummer)
                          ]
                          [ text "Avbryt" ]
                ]
        False ->
            div [][Button.render Mdl
                      [ 10, 1 ]
                      model.mdl
                      [ Button.ripple
                      -- , Button.colored
                      , Button.raised
                      , Options.onClick (FinishedChangeTelefonnummer)
                      -- , css "margin-left" "1em"
                      -- , Options.onClick (SearchAnsatt "Test")
                      ]
                      [ text "Ok" ]
            ]

viewChangeTelefonnummerStatus : Model -> Html Msg
viewChangeTelefonnummerStatus model =
          Options.div [] [text model.statusText]

viewAnsattInfo : Model -> AnsattItem -> Html Msg
viewAnsattInfo model ansatt =
    let
        tittel = ansatt.tittel
                 |> Maybe.withDefault ""
    in

    div [][ showText p Typo.headline "Endre telefonnummer"
          , showText p Typo.headline (ansatt.fornavn ++ " " ++ ansatt.etternavn)
          , Options.styled p [ Typo.body2 ] [ text "Arbeidssted: IT seksjonen" ]
          , Options.styled p [ Typo.body2 ] [ text ("Tittel: " ++ tittel) ]
          , showText p Typo.body2 "Nærmeste leder: Knut Fredvik"
    ]

viewTelefonInput : Model -> AnsattItem -> Html Msg
viewTelefonInput model ansatt =
    div [][ Textfield.render Mdl [2,2] model.mdl
            [ Textfield.label "Fasttelefon"
            , Textfield.floatingLabel
            , when (not model.enableEdit) Textfield.disabled
            , Textfield.text_
            , ansatt.phoneNumber
              |> Maybe.withDefault ""
              |> Textfield.value
            , when (False) <|Textfield.error ""
            , Options.onInput (UpdateAnsattPhone)
            -- , options.oninput (searchansatt)
            ]
            []
          , Textfield.render Mdl [2, 3] model.mdl
            [ Textfield.label "Internnummer"
            , Textfield.floatingLabel
            , when (not model.enableEdit) Textfield.disabled
            , Textfield.text_
            , Textfield.value "-"
            -- , Options.onInput (SearchAnsatt)
            ]
            []
          , Textfield.render Mdl [2, 4] model.mdl
            [ Textfield.label "Hjemmekontor SMS"
            , Textfield.floatingLabel
            , when (not model.enableEdit) Textfield.disabled
            , Textfield.text_
            , Textfield.value "-"
            ]
            []
    ]
