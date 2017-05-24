module Views.StandardFilter exposing (visStandardFilter, KonfigurasjonStandardFilter)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Typography as Typography
import Material.Toggles as Toggles
import Material.Textfield as Textfield
import Material.Spinner as Loading
import Types exposing (..)
import RemoteData exposing (WebData, RemoteData(..))


type alias KonfigurasjonStandardFilter msg =
    { filterMsg : FilterType -> msg
    , nullstillMsg : msg
    , filterNavnMsg : String -> msg
    , mdlMsg : Material.Msg msg -> msg
    , mdlModel : Material.Model
    }


visStandardFilter : WebData AppMetadata -> Filter -> KonfigurasjonStandardFilter msg -> Html msg
visStandardFilter metadata filter konfigurasjon =
    Options.div
        [ css "margin-top"
            "5px"
        , css
            "margin-left"
            "5px"
        ]
        [ Button.render konfigurasjon.mdlMsg
            [ 1944 ]
            konfigurasjon.mdlModel
            [ Button.fab
            , Button.ripple
            , Options.onClick konfigurasjon.nullstillMsg
            , Options.css "margin" "2px"
            , Options.css "float" "right"
            ]
            [ Icon.i "clear" ]
        , Options.div [ Typo.title ]
            [ text "Filtrer" ]
        , Textfield.render konfigurasjon.mdlMsg
            [ 3212 ]
            konfigurasjon.mdlModel
            [ Textfield.label "Navn"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value <| filter.navnFilter
            , Options.onInput (konfigurasjon.filterNavnMsg)
            ]
            []
        , visAvansertFilter metadata filter konfigurasjon
        ]


visAvansertFilter : WebData AppMetadata -> Filter -> KonfigurasjonStandardFilter msg -> Html msg
visAvansertFilter metadata filter konfigurasjon =
    case metadata of
        NotAsked ->
            text "Venter på henting av metadata.."

        Loading ->
            Options.div []
                [ Loading.spinner [ Loading.active True ]
                ]

        Failure err ->
            text "Feil ved henting av data"

        Success data ->
            visStandardFilterSuksess filter konfigurasjon data


visStandardFilterSuksess : Filter -> KonfigurasjonStandardFilter msg -> AppMetadata -> Html msg
visStandardFilterSuksess model konfigurasjon metadata =
    Options.div []
        [ text "Aktivitetstyper"
        , Options.div []
            (metadata.aktivitetstyper
                |> List.indexedMap (\index item -> visAktivitetTypeFilter model item index konfigurasjon)
            )
        , text "Skoler"
        , Options.div []
            (metadata.skoler
                |> List.indexedMap (\index item -> visSkoleTypeFilter model item index konfigurasjon)
            )
        ]


visAktivitetTypeFilter : Filter -> AktivitetsType -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visAktivitetTypeFilter model type_ index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 5, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (AktivitetsTypeFilter type_.id))
        , Toggles.ripple
        , Toggles.value (List.member type_.id model.aktivitetsTypeFilter)
        ]
        [ text type_.navn ]


visSkoleTypeFilter : Filter -> Skole -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visSkoleTypeFilter model skole index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 9, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (SkoleFilter skole.id))
        , Toggles.ripple
        , Toggles.value (List.member skole.id model.skoleFilter)
        ]
        [ text skole.navn ]
