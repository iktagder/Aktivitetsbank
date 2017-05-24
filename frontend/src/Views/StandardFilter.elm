module Views.StandardFilter exposing (visStandardFilter)

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


visStandardFilter : Filter -> (Material.Msg msg -> msg) -> Material.Model -> (FilterType -> msg) -> AppMetadata -> Html msg
visStandardFilter model mdlMsg mdlModel filterMsg metadata =
    Options.div []
        [ text "Aktivitetstyper"
        , Options.div []
            (metadata.aktivitetstyper
                |> List.indexedMap (\index item -> visAktivitetTypeFilter model item index mdlMsg mdlModel filterMsg)
            )
        , text "Skoler"
        , Options.div []
            (metadata.skoler
                |> List.indexedMap (\index item -> visSkoleTypeFilter model item index mdlMsg mdlModel filterMsg)
            )
        ]


visAktivitetTypeFilter : Filter -> AktivitetsType -> Int -> (Material.Msg msg -> msg) -> Material.Model -> (FilterType -> msg) -> Html msg
visAktivitetTypeFilter model type_ index mdlMsg mdlModel filterMsg =
    Toggles.checkbox mdlMsg
        [ 5, index ]
        mdlModel
        [ Options.onToggle (filterMsg (AktivitetsTypeFilter type_.id))
        , Toggles.ripple
        , Toggles.value (List.member type_.id model.aktivitetsTypeFilter)
        ]
        [ text type_.navn ]


visSkoleTypeFilter : Filter -> Skole -> Int -> (Material.Msg msg -> msg) -> Material.Model -> (FilterType -> msg) -> Html msg
visSkoleTypeFilter model skole index mdlMsg mdlModel filterMsg =
    Toggles.checkbox mdlMsg
        [ 9, index ]
        mdlModel
        [ Options.onToggle (filterMsg (SkoleFilter skole.id))
        , Toggles.ripple
        , Toggles.value (List.member skole.id model.skoleFilter)
        ]
        [ text skole.navn ]
