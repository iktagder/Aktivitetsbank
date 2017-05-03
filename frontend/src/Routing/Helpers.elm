module Routing.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))
import Types exposing (..)


reverseRoute : Route -> String
reverseRoute route =
    case route of
        RouteAktivitetsListe ->
            "#/aktiviteter"

        RouteTelefonskjema ->
            "#/telefonskjema"

        RouteAnsattPortal ->
            "#/ansatt-portal"

        RouteLederForesporsel ->
            "#/leder-foresporsel"

        RouteTilgangsadministrasjon ->
            "#/tilgangsadministrasjon"

        RouteAktivitetOpprett ->
            "#/opprettaktivitet"

        RouteAktivitetsDetalj id ->
            "#/aktiviteter/" ++ id

        _ ->
            "#/"


routeParser : Url.Parser (Route -> a) a
routeParser =
    Url.oneOf
        [ Url.map RouteAktivitetsListe Url.top
        , Url.map RouteAnsattPortal (Url.s "ansatt-portal")
        , Url.map RouteLederForesporsel (Url.s "leder-foresporsel")
        , Url.map RouteTilgangsadministrasjon (Url.s "tilgangsadministrasjon")
        , Url.map RouteTelefonskjema (Url.s "telefonskjema")
        , Url.map RouteAktivitetsListe (Url.s "aktiviteter")
        , Url.map RouteAktivitetOpprett (Url.s "opprettaktivitet")
        , Url.map RouteAktivitetsDetalj (Url.s "aktiviteter" </> Url.string)
        ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute



-- fromTabToRoute : Int -> Route
-- fromTabToRoute tabIndex =
--     case tabIndex of
--         0 -> RouteTelefonskjema
--         1 -> RouteAnsattPortal
--         2 -> RouteLederForesporsel
--         3 -> RouteTilgangsadministrasjon
--         _ -> RouteTelefonskjema
--
-- fromRouteToTab : Route -> Int
-- fromRouteToTab route =
--     case route of
--         RouteTelefonskjema -> 0
--         RouteAnsattPortal -> 1
--         RouteLederForesporsel -> 2
--         RouteTilgangsadministrasjon -> 3
--         _ -> 0
