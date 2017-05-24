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
import Types exposing (..)


type alias KonfigurasjonStandardFilter msg =
    { filterMsg : FilterType -> msg
    , nullstillMsg : msg
    , filterNavnMsg : String -> msg
    , mdlMsg : Material.Msg msg -> msg
    , mdlModel : Material.Model
    }


visStandardFilter : Filter -> KonfigurasjonStandardFilter msg -> AppMetadata -> Html msg
visStandardFilter model konfigurasjon metadata =
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
