module App exposing (..)

import Html exposing (Html, div, img, text)
import Material as Material
import Material.Icon as Icon
import Material.Layout as Layout


-- MODEL


type alias Model =
    { mdl : Material.Model
    , aktiviteter : List Aktivitet
    }


type alias Aktivitet =
    { navn : String
    , beskrivelse : String
    , omfang : Int
    , skole : String
    , aktivitetstype : String
    , deltakere : List Deltaker
    }


type alias Deltaker =
    { programomrade : String
    , trinn : String
    , fag : String
    , timer : String
    , kompetansemal : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { mdl = Material.model
      , aktiviteter = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header = viewHeader model
        , drawer = []
        , tabs = ( [], [] )
        , main = viewMain model
        }


viewHeader : Model -> List (Html Msg)
viewHeader model =
    [ Layout.row []
        [ Layout.title
            [{--Options.onClick <| NavigateTo RouteOrganisasjoner --}
            ]
            [ text "Aktivitetsbank" ]
        , Layout.spacer
        , Layout.navigation
            [{--Options.onClick <| NavigateTo RouteInnlogging --}
            ]
            [ Layout.link [] [ Icon.view "face" [ Icon.size18 ], text " Innlogging" ]
            ]
        ]
    ]


{-| Må inneholde funksjonalitet for å:
      - Vise liste over aktiveter
      - Vise opplysninger om en aktivet
      - Endre en aktivitet
-}
viewMain : Model -> List (Html Msg)
viewMain model =
    []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
