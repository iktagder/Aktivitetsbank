module Views.StandardFilter exposing (visStandardFilter, visGjeldendeFilter, KonfigurasjonStandardFilter)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Chip as Chip
import Material.Typography as Typography
import Material.Toggles as Toggles
import Material.Textfield as Textfield
import Material.Spinner as Loading
import Types exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Dict


type alias KonfigurasjonStandardFilter msg =
    { filterMsg : FilterType -> msg
    , nullstillMsg : msg
    , filterNavnMsg : String -> msg
    , ekspanderFilterTypeMsg : EkspandertFilter -> msg
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
        -- [ Button.render konfigurasjon.mdlMsg
        --     [ 1944 ]
        --     konfigurasjon.mdlModel
        --     [ Button.fab
        --     , Button.ripple
        --     , Options.onClick konfigurasjon.nullstillMsg
        --     , Options.css "margin" "2px"
        --     , Options.css "float" "right"
        --     ]
        --     [ Icon.i "clear" ]
        [ Options.div [ Typo.title ]
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
        [ visAktivitetTypeFilter model metadata
            |> visAktivtFilter model AktivitetsTypeFilterEkspandert "Aktivitetstyper" konfigurasjon
        , visSkoleTypeFilter model metadata
            |> visAktivtFilter model SkoleFilterEkspandert "Skoler" konfigurasjon
        , visUtdanningsprogramFilter model metadata
            |> visAktivtFilter model UtdanningsprogramFilterEkspandert "Utdanningsprogram" konfigurasjon
        , visTrinnFilter model metadata
            |> visAktivtFilter model TrinnFilterEkspandert "Trinn" konfigurasjon
        , visFagFilter model metadata
            |> visAktivtFilter model FagFilterEkspandert "Fag" konfigurasjon
        ]


visAktivitetTypeFilter : Filter -> AppMetadata -> KonfigurasjonStandardFilter msg -> Html msg
visAktivitetTypeFilter model metadata konfigurasjon =
    Options.div
        [ css "margin-left" "2rem"
        , css "margin-top" "1rem"
        ]
        (metadata.aktivitetstyper
            |> List.indexedMap (\index item -> visAktivitetTypeFilterRad model item index konfigurasjon)
        )


visAktivitetTypeFilterRad : Filter -> AktivitetsType -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visAktivitetTypeFilterRad model type_ index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 5, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (AktivitetsTypeFilter type_.id type_.navn))
        , Toggles.ripple
        , Toggles.value (Dict.member type_.id model.aktivitetsTypeFilter)
        ]
        [ text <| String.left 30 type_.navn ]


visSkoleTypeFilter : Filter -> AppMetadata -> KonfigurasjonStandardFilter msg -> Html msg
visSkoleTypeFilter model metadata konfigurasjon =
    Options.div
        [ css "margin-left" "2rem"
        , css "margin-top" "1rem"
        ]
        (metadata.skoler
            |> List.indexedMap (\index item -> visSkoleTypeFilterRad model item index konfigurasjon)
        )


visSkoleTypeFilterRad : Filter -> Skole -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visSkoleTypeFilterRad model skole index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 9, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (SkoleFilter skole.id skole.navn))
        , Toggles.ripple
        , Toggles.value (Dict.member skole.id model.skoleFilter)
        ]
        [ text <| String.left 30 skole.navn ]


visUtdanningsprogramFilter : Filter -> AppMetadata -> KonfigurasjonStandardFilter msg -> Html msg
visUtdanningsprogramFilter model metadata konfigurasjon =
    Options.div
        [ css "margin-left" "2rem"
        , css "margin-top" "1rem"
        ]
        (metadata.utdanningsprogrammer
            |> List.indexedMap (\index item -> visUtdanningsprogramFilterRad model item index konfigurasjon)
        )


visUtdanningsprogramFilterRad : Filter -> Utdanningsprogram -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visUtdanningsprogramFilterRad model utdanningsprogram index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 19, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (UtdanningsprogramFilter utdanningsprogram.id utdanningsprogram.navn))
        , Toggles.ripple
        , Toggles.value (Dict.member utdanningsprogram.id model.utdanningsprogramFilter)
        ]
        [ text <| String.left 30 utdanningsprogram.navn ]


visTrinnFilter : Filter -> AppMetadata -> KonfigurasjonStandardFilter msg -> Html msg
visTrinnFilter model metadata konfigurasjon =
    Options.div
        [ css "margin-left" "2rem"
        , css "margin-top" "1rem"
        ]
        (metadata.trinnListe
            |> List.indexedMap (\index item -> visTrinnFilterRad model item index konfigurasjon)
        )


visTrinnFilterRad : Filter -> Trinn -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visTrinnFilterRad model trinn index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 49, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (TrinnFilter trinn.id trinn.navn))
        , Toggles.ripple
        , Toggles.value (Dict.member trinn.id model.trinnFilter)
        ]
        [ text <| String.left 30 trinn.navn ]


visFagFilter : Filter -> AppMetadata -> KonfigurasjonStandardFilter msg -> Html msg
visFagFilter model metadata konfigurasjon =
    Options.div
        [ css "margin-left" "2rem"
        , css "margin-top" "1rem"
        ]
        (metadata.fagListe
            |> List.indexedMap (\index item -> visFagFilterRad model item index konfigurasjon)
        )


visFagFilterRad : Filter -> Fag -> Int -> KonfigurasjonStandardFilter msg -> Html msg
visFagFilterRad model fag index konfigurasjon =
    Toggles.checkbox konfigurasjon.mdlMsg
        [ 59, index ]
        konfigurasjon.mdlModel
        [ Options.onToggle (konfigurasjon.filterMsg (FagFilter fag.id fag.navn))
        , Toggles.ripple
        , Toggles.value (Dict.member fag.id model.fagFilter)
        ]
        [ text <| String.left 30 fag.navn ]


visAktivtFilter : Filter -> EkspandertFilter -> String -> KonfigurasjonStandardFilter msg -> (KonfigurasjonStandardFilter msg -> Html msg) -> Html msg
visAktivtFilter filter gjeldendeFilter filterNavn konfigurasjon visInnhold =
    if filter.ekspandertFilter == gjeldendeFilter then
        Options.div
            []
            [ Options.div
                [ Options.onClick (konfigurasjon.ekspanderFilterTypeMsg gjeldendeFilter)
                , cs "vis-navigering"
                ]
                [ text <| "< " ++ filterNavn ]
            , visInnhold konfigurasjon
            ]
    else
        Options.div
            [ Options.onClick (konfigurasjon.ekspanderFilterTypeMsg gjeldendeFilter)
            , cs "vis-navigering"
            ]
            [ text <| "> " ++ filterNavn ]


visGjeldendeFilter : Filter -> (FilterType -> msg) -> Html msg
visGjeldendeFilter filter slettMsg =
    Options.div []
        [ Options.span []
            (filter.skoleFilter
                |> Dict.toList
                |> List.indexedMap (\index ( id, navn ) -> visGjeldendeFilterEnhet navn slettMsg (SkoleFilter id navn))
            )
        , Options.span []
            (filter.aktivitetsTypeFilter
                |> Dict.toList
                |> List.indexedMap (\index ( id, navn ) -> visGjeldendeFilterEnhet navn slettMsg (AktivitetsTypeFilter id navn))
            )
        , Options.span []
            (filter.utdanningsprogramFilter
                |> Dict.toList
                |> List.indexedMap (\index ( id, navn ) -> visGjeldendeFilterEnhet navn slettMsg (UtdanningsprogramFilter id navn))
            )
        , Options.span []
            (filter.trinnFilter
                |> Dict.toList
                |> List.indexedMap (\index ( id, navn ) -> visGjeldendeFilterEnhet navn slettMsg (TrinnFilter id navn))
            )
        , Options.span []
            (filter.fagFilter
                |> Dict.toList
                |> List.indexedMap (\index ( id, navn ) -> visGjeldendeFilterEnhet navn slettMsg (FagFilter id navn))
            )
        ]


visGjeldendeFilterEnhet : String -> (FilterType -> msg) -> FilterType -> Html msg
visGjeldendeFilterEnhet filterNavn slettMsg filterType =
    Chip.span
        [ Chip.deleteIcon "cancel"
        , Chip.deleteClick
            (slettMsg filterType)
        ]
        [ Chip.content []
            [ text filterNavn ]
        ]
