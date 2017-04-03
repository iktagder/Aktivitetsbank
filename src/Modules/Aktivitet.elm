module Modules.Aktivitet exposing (..)

import Html exposing (..)
import Material as Material
import Material.Grid as Grid exposing (..)
import Material.Options as Options
import Material.Table as Table
import Material.Toggles as Toggles


-- MODEL


type alias Model =
    { mdl : Material.Model
    , aktiviteter : List Aktivitet
    , skoler : List String
    , skolefilter : String
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


initAktivitet1 : Aktivitet
initAktivitet1 =
    { navn = "Aktivitetsdag"
    , beskrivelse = "Kroppsøving er et allmenndannende fag som skal insirere til en fysisk aktivitet livsstil og livslang rørsleglede. Rørsle er grunneleggende hos mennesket og fysisk aktivitet er viktig for å fremme god helse."
    , omfang = 10
    , skole = "KKG"
    , aktivitetstype = "Fellesaktivitet"
    , deltakere = []
    }


initAktivitet2 : Aktivitet
initAktivitet2 =
    { navn = "Skitur"
    , beskrivelse = "Skitur for hele KKG."
    , omfang = 10
    , skole = "KKG"
    , aktivitetstype = "Fellesaktivitet"
    , deltakere = []
    }


model : Model
model =
    { mdl = Material.model
    , aktiviteter = [ initAktivitet1, initAktivitet2 ]
    , skoler = [ "KKG", "TAN" ]
    , skolefilter = ""
    }



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleSkole String
    | NoMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl m ->
            Material.update Mdl m model

        ToggleSkole skole ->
            { model | skolefilter = skole } ! []

        NoMsg ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    Grid.grid [ Options.css "text-align" "left" ]
        [ cell [ size Desktop 2 ]
            [ h4 [] [ text "-" ]
            , h5 [] [ text "Filter" ]
            , h6 [] [ text "Skole" ]
            , filterSkolerSkole model "KKG" 1
            , filterSkolerSkole model "BYR" 2
            ]
        , cell
            [ size Desktop 8
            ]
            [ h4 [] [ text "Aktiviteter" ]
            , viewAktiviteterTable model
            ]
        ]


filterSkolerSkole : Model -> String -> Int -> Html Msg
filterSkolerSkole model skole nr =
    Toggles.radio Mdl
        [ 0, nr ]
        model.mdl
        [ Toggles.ripple, Toggles.value False ]
        [ text skole ]


viewAktiviteterTable : Model -> Html Msg
viewAktiviteterTable model =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "Navn" ]
                , Table.th [ Options.css "text-align" "left" ] [ text "Beskrivelse" ]
                , Table.th [] [ text "Omfang" ]
                , Table.th [] [ text "Skole" ]
                ]
            ]
        , Table.tbody []
            (model.aktiviteter |> List.map (\aktivitet -> viewAktiviteterTableRow aktivitet))
        ]


viewAktiviteterTableRow : Aktivitet -> Html Msg
viewAktiviteterTableRow aktivitet =
    Table.tr []
        [ Table.td [] [ text aktivitet.navn ]
        , Table.td [ Options.css "text-align" "left", Options.css "white-space" "normal" ] [ text aktivitet.beskrivelse ]
        , Table.td [ Table.numeric ] [ text <| toString aktivitet.omfang ]
        , Table.td [] [ text aktivitet.skole ]
        ]
