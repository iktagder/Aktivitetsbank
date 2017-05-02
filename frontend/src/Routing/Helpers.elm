module Routing.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))
import Types exposing (..)


reverseRoute : Route -> String
reverseRoute route =
    case route of
        RouteTelefonskjema ->
            "#/telefonskjema"

        RouteAnsattPortal ->
            "#/ansatt-portal"

        RouteLederForesporsel ->
            "#/leder-foresporsel"

        RouteTilgangsadministrasjon ->
            "#/tilgangsadministrasjon"
        _ ->
            "#/"


routeParser : Url.Parser (Route -> a) a
routeParser =
  Url.oneOf
    [ Url.map RouteTelefonskjema Url.top
    , Url.map RouteAnsattPortal (Url.s "ansatt-portal")
    , Url.map RouteLederForesporsel (Url.s "leder-foresporsel")
    , Url.map RouteTilgangsadministrasjon (Url.s "tilgangsadministrasjon")
    , Url.map RouteTelefonskjema (Url.s "telefonskjema")
    ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute

fromTabToRoute : Int -> Route
fromTabToRoute tabIndex =
    case tabIndex of
        0 -> RouteTelefonskjema
        1 -> RouteAnsattPortal
        2 -> RouteLederForesporsel
        3 -> RouteTilgangsadministrasjon
        _ -> RouteTelefonskjema

fromRouteToTab : Route -> Int
fromRouteToTab route =
    case route of
        RouteTelefonskjema -> 0
        RouteAnsattPortal -> 1
        RouteLederForesporsel -> 2
        RouteTilgangsadministrasjon -> 3
        _ -> 0
