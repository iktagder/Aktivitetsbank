module App exposing (..)

import Html exposing (Html, div, img, text)
import Material as Material
import Material.Icon as Icon
import Material.Layout as Layout
import Modules.Aktivitet as Aktivitet
import Material.Helpers as Helpers


-- MODEL


type alias Model =
    { mdl : Material.Model
    , aktiviteter : Aktivitet.Model
    }


model : Model
model =
    { mdl = Material.model
    , aktiviteter = Aktivitet.model
    }


init : String -> ( Model, Cmd Msg )
init x =
    ( model
    , Cmd.none
    )



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | AktivitetMsg Aktivitet.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl m ->
            Material.update Mdl m model

        AktivitetMsg aktivitetMsg ->
            Helpers.lift .aktiviteter
                (\m x -> { m | aktiviteter = x })
                AktivitetMsg
                Aktivitet.update
                aktivitetMsg
                model



{--let
                ( aktiviteter, aktivitetCmd ) =
                    Aktivitet.update aktivitetMsg model.aktiviteter
            in
                ( { model | aktiviteter = aktiviteter }, Cmd.map AktivitetMsg aktivitetCmd )
--}
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
    [ Html.map AktivitetMsg (Aktivitet.view model.aktiviteter)
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
