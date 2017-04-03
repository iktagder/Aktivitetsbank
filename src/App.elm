module App exposing (..)

import Html exposing (Html, div, img, text)
import Material as Material
import Material.Icon as Icon
import Material.Layout as Layout
import Pages.AktivitetsListe as Aktiviteter
import Material.Helpers as Helpers
import Material.Grid as Grid


-- MODEL


type alias Model =
    { mdl : Material.Model
    , aktiviteter : Aktiviteter.Model
    , valgtAktivitet : Maybe Aktiviteter.Aktivitet
    }


model : Model
model =
    { mdl = Material.model
    , aktiviteter = Aktiviteter.model
    , valgtAktivitet = Nothing
    }


init : String -> ( Model, Cmd Msg )
init ikkeibruk =
    ( model
    , Cmd.none
    )



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | AktiviteterMsg Aktiviteter.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl m ->
            Material.update Mdl m model

        AktiviteterMsg aktiviteterMsg ->
            let
                ( aktiviteter_, cmd, valgtAktivitet_ ) =
                    Aktiviteter.update aktiviteterMsg model.aktiviteter
            in
                ( { model | aktiviteter = aktiviteter_, valgtAktivitet = valgtAktivitet_ }
                , Cmd.map AktiviteterMsg cmd
                )



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
            [ Layout.link [] [ Icon.view "face" [ Icon.size18 ], text " adm\\oae" ]
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
    [ Html.map AktiviteterMsg (Aktiviteter.view model.aktiviteter)
    , Grid.grid []
        [ Grid.cell [ Grid.size Grid.Desktop 10, Grid.offset Grid.Desktop 2 ]
            [ text <| toString model.valgtAktivitet
            ]
        ]
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
