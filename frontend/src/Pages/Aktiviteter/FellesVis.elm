module Pages.Aktiviteter.FellesVis exposing (..)

import Html exposing (Html, text, div, span, p, a)
import Material
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Material.Button as Button
import Material.Options as Options exposing (when, css, cs, Style, onClick)
import Material.Typography as Typo
import Material.Typography as Typography
import Types exposing (..)


type BekreftSlettingMsg
    = Av
    | VisBekreftSletting
    | SlettingBekreftet
    | SlettingAvbrutt


type alias KonfigurasjonSlett msg =
    { bekreftMsg : BekreftSlettingMsg -> msg
    , mdlMsg : Material.Msg msg -> msg
    , mdlModel : Material.Model
    , bekreftSporsmaal : String
    , avbrytTekst : String
    , bekreftTekst : String
    }


visSlett : BekreftSlettingMsg -> KonfigurasjonSlett msg -> Taco -> Html msg
visSlett bekreftSletting konfigurasjon taco =
    case bekreftSletting of
        Av ->
            visSlettIkon konfigurasjon

        VisBekreftSletting ->
            visSlettBekreft konfigurasjon

        SlettingBekreftet ->
            text "Sletter .."

        SlettingAvbrutt ->
            text "Sletting avbrutt"


visSlettIkon : KonfigurasjonSlett msg -> Html msg
visSlettIkon konfigurasjon =
    Options.span [ Options.css "float" "right" ]
        [ Icon.view "delete_sweep"
            [ Tooltip.attach konfigurasjon.mdlMsg [ 145, 100 ]
            , Options.css "float" "right"
            , Options.onClick <| konfigurasjon.bekreftMsg VisBekreftSletting
            , Icon.size24
            , cs "standard-ikon"
            ]
        , Tooltip.render konfigurasjon.mdlMsg [ 145, 100 ] konfigurasjon.mdlModel [ Tooltip.large ] [ text konfigurasjon.bekreftTekst ]
        ]


visSlettBekreft : KonfigurasjonSlett msg -> Html msg
visSlettBekreft konfigurasjon =
    Options.span [ Options.css "float" "right" ]
        [ Options.styled div [ Typo.title ] [ text konfigurasjon.bekreftSporsmaal ]
        , Button.render konfigurasjon.mdlMsg
            [ 347, 1 ]
            konfigurasjon.mdlModel
            [ Button.ripple
            , Button.colored
            , Button.raised
            , Options.onClick (konfigurasjon.bekreftMsg SlettingAvbrutt)
            , css "float" "left"
            , Options.css "margin" "6px 6px"
            ]
            [ text konfigurasjon.avbrytTekst ]
        , Button.render konfigurasjon.mdlMsg
            [ 41, 404 ]
            konfigurasjon.mdlModel
            [ Button.ripple
            , Button.accent
            , Button.raised
            , Options.onClick (konfigurasjon.bekreftMsg SlettingBekreftet)
            , css "float" "left"
            , Options.css "margin" "6px 6px"
            ]
            [ text konfigurasjon.bekreftTekst ]
        ]
