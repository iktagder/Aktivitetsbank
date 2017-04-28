module Pages.AktivitetsListe exposing (..)

import Html exposing (..)
import Material as Material
import Material.Grid as Grid exposing (..)
import Material.Options as Options
import Material.Table as Table
import Material.Toggles as Toggles
import Material.Button as Button
import Material.Icon as Icon


-- MODEL


type alias Model =
    { mdl : Material.Model
    , aktiviteter : List Aktivitet
    , skoler : List String
    , skolefilter : String
    }


type alias Aktivitet =
    { id : Int
    , navn : String
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
    { id = 1
    , navn = "Aktivitetsdag"
    , beskrivelse = "Kroppsøving er et allmenndannende fag som skal insirere til en fysisk aktivitet livsstil og livslang rørsleglede. Rørsle er grunneleggende hos mennesket og fysisk aktivitet er viktig for å fremme god helse."
    , omfang = 10
    , skole = "KKG"
    , aktivitetstype = "Fellesaktivitet"
    , deltakere = []
    }


initAktivitet2 : Aktivitet
initAktivitet2 =
    { id = 2
    , navn = "Skitur"
    , beskrivelse = "Skitur for hele KKG."
    , omfang = 10
    , skole = "KKG"
    , aktivitetstype = "Fellesaktivitet"
    , deltakere = []
    }


initAktivitet3 : Aktivitet
initAktivitet3 =
    { id = 3
    , navn = "Operasjon Dagsverk"
    , beskrivelse = "Operasjon Dagsverk (OD) er en årlig solidaritetsaksjon arrangert av, med og for ungdom. Aksjonen er underlagt Elevorganisasjonen."
    , omfang = 10
    , skole = "BYR"
    , aktivitetstype = "Fellesaktivitet"
    , deltakere = []
    }


model : Model
model =
    { mdl = Material.model
    , aktiviteter = [ initAktivitet1, initAktivitet2, initAktivitet3 ]
    , skoler = [ "KKG", "TAN" ]
    , skolefilter = ""
    }



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleSkole String
    | VelgEnAktivitet Aktivitet
    | NoMsg


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Aktivitet )
update msg model =
    case msg of
        Mdl m ->
            let
                ( mo, c ) =
                    Material.update Mdl m model
            in
                ( mo, c, Nothing )

        ToggleSkole skole ->
            ( { model | skolefilter = skole }, Cmd.none, Nothing )

        VelgEnAktivitet aktivitet ->
            ( model, Cmd.none, Just aktivitet )

        NoMsg ->
            ( model, Cmd.none, Nothing )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Grid.grid []
            [ cell [ size Desktop 2 ]
                [ h4 [] [ text "-" ]
                , h5 [] [ text "Filter" ]
                , h6 [] [ text "SKOLE" ]
                , filterSkolerSkole model "Alle skoler" "" 1
                , filterSkolerSkole model "KKG" "KKG" 2
                , filterSkolerSkole model "BYR" "BYR" 3
                , h6 [] [ text "PROGRAMOMRÅDE" ]
                ]
            , cell
                [ size Desktop 10
                ]
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.fab
                    , Button.ripple
                      --, Button.onClick MyClickMsg
                    , Options.css "float" "right"
                    ]
                    [ Icon.i "add" ]
                , h4 []
                    [ text "Aktiviteter"
                    ]
                , viewAktiviteterTable model
                ]
            ]
        ]


filterSkolerSkole : Model -> String -> String -> Int -> Html Msg
filterSkolerSkole model skole sfilter nr =
    Html.div []
        [ Toggles.radio
            Mdl
            [ 0, nr ]
            model.mdl
            [ Toggles.ripple
            , Toggles.value
                (sfilter == model.skolefilter)
            , Options.onToggle (ToggleSkole sfilter)
            ]
            [ text skole ]
        ]


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
            (model.aktiviteter
                |> List.filter (\n -> model.skolefilter == "" || n.skole == model.skolefilter)
                |> List.map (\aktivitet -> viewAktiviteterTableRow aktivitet)
            )
        ]


viewAktiviteterTableRow : Aktivitet -> Html Msg
viewAktiviteterTableRow aktivitet =
    Table.tr [ Options.onClick <| VelgEnAktivitet aktivitet ]
        [ Table.td [] [ text aktivitet.navn ]
        , Table.td [ Options.css "text-align" "left", Options.css "white-space" "normal" ] [ text aktivitet.beskrivelse ]
        , Table.td [ Table.numeric ] [ text <| toString aktivitet.omfang ]
        , Table.td [] [ text aktivitet.skole ]
        ]
